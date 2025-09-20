import SwiftUI

class GameState: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var gameStarted: Bool = false
    @Published var chatMessages: [Message] = []
    @Published var thinking: Bool = false
    @Published var activeTricks: [ActiveTrick] = []
    @Published var maxActiveTricks: Int = 3
    @Published var lastGuess: Int = 0
}

@MainActor
class GameManager: ObservableObject {
    @ObservedObject var state: GameState
    
    init(state: GameState) {
        self.state = state
    }
    
    func startNewGame() {
        state.targetNumber = Int.random(in: 1...999)
        state.attempts = 0
        state.gameWon = false
        state.gameStarted = true
        state.activeTricks = []
        state.chatMessages = [
            Message(SystemMessage(type: .welcome))
        ]
    }
    
    func makeGuess(_ _guess: Int) {
        state.thinking = true
        state.attempts += 1

        Task {
            let guess = await triggerActiveTricksOnGuess(state.targetNumber, _guess)

            state.lastGuess = guess

            await showPlayerGuess(guess)

            if guess == state.targetNumber {
                await winGame()
            } else {
                await continueGame(guess: guess)

                state.thinking = false
            }
        }
    }
    
    fileprivate func continueGame(guess: Int) async {
        await showMissed(guess: guess)
        
        await triggerActiveTricksOnTurn()

        await removeExpiredTricks()
        
        // Spawn NEW trick
        
        let newTrick = AllTricks.randomTrick(excluding: state.activeTricks)
        
        if (newTrick.duration > 0 && state.activeTricks.count <=  state.maxActiveTricks) {
            // new trick is not an immediate action, keep it - if there are enough room
            withAnimation(.linear(duration: 0.2)) {
                state.activeTricks.append(ActiveTrick(trick: newTrick, remainingDuration: newTrick.duration))
            }
        }
        
        let newTrickActivated = await newTrick.triggerOnCreate(to: state)
        if (newTrickActivated) {
            await showTrick(newTrick)
        }
    }
    
    fileprivate func triggerActiveTricksOnGuess(_ target: Int,_ _guess: Int) async -> Int {
        var guess = _guess
        for activeTrick in state.activeTricks {
            let newGuess = activeTrick.trick.triggerOnGuess(target: target, guess: guess)
            if (newGuess != nil) {
                guess = newGuess!
                await showTrick(activeTrick.trick)
            }
        }
        return guess
    }
    
    fileprivate func triggerActiveTricksOnTurn() async {
        for activeTrick in state.activeTricks {
            let trickTriggered = await activeTrick.trick.triggerOnTurn(to: self.state)
            if (trickTriggered) {
                await showTrick(activeTrick.trick)
            }            
        }
    }
    
    private func triggerActiveTricksForMessage(to message: SystemMessage) async -> SystemMessage {
        var current = message
        for activeTrick in state.activeTricks {
            let newMessage = activeTrick.trick.triggerOnShowMiss(systemMessage: current)
            if newMessage != nil {
                await showTrick(activeTrick.trick)
            }
            current = newMessage ?? current
        }
        return current
    }
    
    fileprivate func removeExpiredTricks() async {
        // Reduce duration and remove expired tricks
        withAnimation(.linear(duration: 0.2)) {
            state.activeTricks = state.activeTricks.compactMap { activeTrick in
                let newDuration = activeTrick.remainingDuration - 1
                return newDuration > 0 ? ActiveTrick(trick: activeTrick.trick, remainingDuration: newDuration) : nil
            }
        }
    }
    
    fileprivate func showTrick(_ trick: any GameTrick) async {
        if (trick.isNoop) {
            return
        }
        try? await Task.sleep(nanoseconds: randomTrickTime())
        
        await MainActor.run {
            state.chatMessages.append(Message(TrickMessage(trick)))
        }
    }
    
    fileprivate func winGame() async {
        await MainActor.run {
            state.gameWon = true
            state.chatMessages.append(
                Message(SystemMessage(type: .victory(targetNumber: state.targetNumber, attempts: state.attempts)))
            )
            state.thinking = false
        }
    }

    fileprivate func showMissed(guess: Int) async {
        let sysMsg: SystemMessage = guess < state.targetNumber
            ? SystemMessage(type: .tooLow(currentGuess: guess))
            : SystemMessage(type: .tooHigh(currentGuess: guess))
        let newMsg = await triggerActiveTricksForMessage(to: sysMsg)
        state.chatMessages.append(Message(newMsg))
    }
    
    fileprivate func showPlayerGuess(_ guess: Int) async {
        await MainActor.run {
            state.chatMessages.append(Message(PlayerMessage(guess: guess, attempt: state.attempts)))
        }
        try? await Task.sleep(nanoseconds: randomThinkingTime())
    }
    
    private func randomThinkingTime() -> UInt64 {
        let seconds = Double.random(in: 0.5...1.5)
        return UInt64(seconds * 1_000_000_000)
    }
    
    private func randomTrickTime() -> UInt64 {
        let seconds = Double.random(in: 0.5...1)
        return UInt64(seconds * 1_000_000_000)
    }
    
}
