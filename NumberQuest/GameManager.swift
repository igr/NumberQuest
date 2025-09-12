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
            Message(SystemMessage(type: .welcome)),
            Message(SystemMessage(type: .debug(activeTricks: [])))
        ]
    }
    
    func makeGuess(_ guess: Int) {
        thinking = true
        attempts += 1
        
        Task {
            await showPlayerGuess(guess)

            if guess == targetNumber {
                await winGame()
            } else {
                await continueGame(guess: guess)

                thinking = false
            }
        }
    }
    
    fileprivate func continueGame(guess: Int) async {
        await showMissed(guess: guess)
        
        let newTrick = AllTricks.randomTrick(excluding: activeTricks)
        
        if (newTrick.duration > 0) {
            // new trick is not an immediate action, keep it.
            activeTricks.append(ActiveTrick(trick: newTrick, remainingDuration: newTrick.duration))
        }
        
        await newTrick.triggerOnCreate(to: self)
        
        await showNewTrick(newTrick)
        
        await processActiveTricks()

        await removeExpiredTricks()
        
        await sendActiveTricksUpdate()
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
        if (trick.isNoop) {
            return
        }
        try? await Task.sleep(nanoseconds: randomTrickTime())
        
        await MainActor.run {
            chatMessages.append(Message(TrickMessage(trick)))
        }
    }
    
    fileprivate func winGame() async {
        await MainActor.run {
            gameWon = true
            chatMessages.append(Message(SystemMessage(type: .victory(targetNumber: targetNumber, attempts: attempts))))
            thinking = false
        }
    }

    fileprivate func showMissed(guess: Int) async {
        await MainActor.run {
            if guess < targetNumber {
                chatMessages.append(Message(SystemMessage(type: .tooLow(currentGuess: guess))))
            } else {
                chatMessages.append(Message(SystemMessage(type: .tooHigh(currentGuess: guess))))
            }
        }
    }
    
    fileprivate func showPlayerGuess(_ guess: Int) async {
        await MainActor.run {
            chatMessages.append(Message(PlayerMessage(guess: guess, attempt: attempts)))
        }
        try? await Task.sleep(nanoseconds: randomThinkingTime())
    }
        
    // MARK: - Active Tricks Status
    private func sendActiveTricksUpdate() async {
        await MainActor.run {
            chatMessages.append(Message(SystemMessage(type: .debug(activeTricks: activeTricks))))
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
