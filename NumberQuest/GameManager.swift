import Foundation

@MainActor
class GameManager: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var gameStarted: Bool = false
    @Published var chatMessages: [Message] = []
    @Published var thinking: Bool = false
    @Published var activeTricks: [ActiveTrick] = []
    
    func startNewGame() {
        targetNumber = Int.random(in: 1...999)
        attempts = 0
        gameWon = false
        gameStarted = true
        activeTricks = []
        chatMessages = [
            Message(SystemMessage(type: .welcome))
        ]
    }
    
    fileprivate func showMissed(guess: Int, isEnd: Bool) async {
        await MainActor.run {
            showMissed(guess)
            if (isEnd) {
                thinking = false
            }
        }
    }
    
    func makeGuess(_ guess: Int) {
        thinking = true
        attempts += 1
        let newTrick = AllTricks.randomTrick(excluding: activeTricks)
        
        Task {
            await showPlayerGuess(guess)
            
            try? await Task.sleep(nanoseconds: randomThinkingTime())
            
            if guess == targetNumber {
                await winGame()
            } else {
                await continueGame(guess: guess, newTrick: newTrick)
            }
        }
    }
    
    fileprivate func continueGame(guess: Int, newTrick: any GameTrick) async {
        await showMissed(guess: guess, isEnd: newTrick.isNoop)
        
        if (newTrick.isNoop) {
            return
        }
        
        // HANDLE NEW TRICK
        
        if (newTrick.duration != 0) {
            activeTricks.append(ActiveTrick(trick: newTrick, remainingDuration: newTrick.duration))
        }
        
        try? await Task.sleep(nanoseconds: randomTrickTime())
        
        await newTrick.triggerOnCreate(to: self)
        
        await showNewTrick(newTrick)
        
        await processActiveTricks()

        await removeExpiredTricks()
    }
    
    fileprivate func processActiveTricks() async {
        for activeTrick in activeTricks {
            await activeTrick.trick.triggerOnTurn(to: self)
        }
    }
    
    fileprivate func removeExpiredTricks() async {
        // Reduce duration and remove expired tricks
        activeTricks = activeTricks.compactMap { activeTrick in
            let newDuration = activeTrick.remainingDuration - 1
            return newDuration > 0 ? ActiveTrick(trick: activeTrick.trick, remainingDuration: newDuration) : nil
        }
    }
    
    fileprivate func showNewTrick(_ trick: any GameTrick) async {
        await MainActor.run {
            chatMessages.append(Message(TrickMessage(trick)))
            thinking = false
        }
    }
    
    fileprivate func winGame() async {
        await MainActor.run {
            gameWon = true
            chatMessages.append(Message(SystemMessage(type: .victory(targetNumber: targetNumber, attempts: attempts))))
            thinking = false
        }
    }
    
    fileprivate func showMissed(_ guess: Int) {
        if guess < targetNumber {
            chatMessages.append(Message(SystemMessage(type: .tooLow(currentGuess: guess))))
        } else {
            chatMessages.append(Message(SystemMessage(type: .tooHigh(currentGuess: guess))))
        }
    }
    
    fileprivate func showPlayerGuess(_ guess: Int) async {
        await MainActor.run {
            chatMessages.append(Message(PlayerMessage(guess: guess, attempt: attempts)))
        }
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
