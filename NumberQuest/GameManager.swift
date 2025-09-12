import SwiftUI

class GameState: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var gameStarted: Bool = false
    @Published var chatMessages: [Message] = []
    @Published var thinking: Bool = false
    @Published var activeTricks: [ActiveTrick] = []
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
            Message(SystemMessage(type: .welcome)),
            Message(SystemMessage(type: .debug(activeTricks: [], target: 0)))
        ]
    }
    
    func makeGuess(_ guess: Int) {
        state.thinking = true
        state.attempts += 1
        
        Task {
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
        
        let newTrick = AllTricks.randomTrick(excluding: state.activeTricks)
        
        if (newTrick.duration > 0) {
            // new trick is not an immediate action, keep it.
            state.activeTricks.append(ActiveTrick(trick: newTrick, remainingDuration: newTrick.duration))
        }
        
        await newTrick.triggerOnCreate(to: state)
        
        await showNewTrick(newTrick)
        
        await processActiveTricks()

        await removeExpiredTricks()
    }
    
    fileprivate func processActiveTricks() async {
        for activeTrick in state.activeTricks {
            await activeTrick.trick.triggerOnTurn(to: self.state)
        }
    }
    
    fileprivate func removeExpiredTricks() async {
        // Reduce duration and remove expired tricks
        state.activeTricks = state.activeTricks.compactMap { activeTrick in
            let newDuration = activeTrick.remainingDuration - 1
            return newDuration > 0 ? ActiveTrick(trick: activeTrick.trick, remainingDuration: newDuration) : nil
        }
    }
    
    fileprivate func showNewTrick(_ trick: any GameTrick) async {
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
        await MainActor.run {
            let sysMsg: SystemMessage = guess < state.targetNumber
                ? SystemMessage(type: .tooLow(currentGuess: guess))
                : SystemMessage(type: .tooHigh(currentGuess: guess))
            state.chatMessages.append(Message(applyTricks(to: sysMsg)))
        }
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
    
    private func applyTricks(to message: SystemMessage) -> SystemMessage {
        state.activeTricks.reduce(message) { current, activeTrick in
            activeTrick.trick.modify(systemMessage: current)
        }
    }
}
