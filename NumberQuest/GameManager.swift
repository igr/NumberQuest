import Foundation

class GameManager: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var gameStarted: Bool = false
    @Published var chatMessages: [Message] = []
    @Published var thinking: Bool = false
    
    func startNewGame() {
        targetNumber = Int.random(in: 1...999)
        attempts = 0
        gameWon = false
        gameStarted = true
        chatMessages = [
            Message(SystemMessage(type: .welcome))
        ]
    }
    
    func makeGuess(_ guess: Int) {
        thinking = true
        
        attempts += 1
        let effect = AllEffects.randomEffect()
        
        Task {
            // Show the player message immediately
            await MainActor.run {
                chatMessages.append(Message(PlayerMessage(guess: guess, attempt: attempts)))
            }
            
            // Wait before responding
            try? await Task.sleep(nanoseconds: randomThinkingTime())
            
            if guess == targetNumber {
                await MainActor.run {
                    winGame()
                }
            } else {
                await MainActor.run {
                    missGuess(guess)

                    if (effect.isNoop) {
                        thinking = false
                    }
                }

                if (!effect.isNoop) {
                    // Second delay before a follow-up message
                    try? await Task.sleep(nanoseconds: randomEffectTime())
                    
                    effect.apply(to: self)
                    
                    await MainActor.run {
                        announceEffect(effect)
                    }
                }
            }
        }
    }
    
    fileprivate func announceEffect(_ effect: any GameEffect) {
        chatMessages.append(Message(EffectMessage(effect)))
        thinking = false
    }
    
    fileprivate func winGame() {
        gameWon = true
        chatMessages.append(Message(SystemMessage(type: .victory(targetNumber: targetNumber, attempts: attempts))))
        thinking = false
    }

    fileprivate func missGuess(_ guess: Int) {
        if guess < targetNumber {
            chatMessages.append(Message(SystemMessage(type: .tooLow(currentGuess: guess))))
        } else {
            chatMessages.append(Message(SystemMessage(type: .tooHigh(currentGuess: guess))))
        }
    }
    
    private func randomThinkingTime() -> UInt64 {
        let seconds = Double.random(in: 0.5...1.5)
        return UInt64(seconds * 1_000_000_000)
    }
    
    private func randomEffectTime() -> UInt64 {
        let seconds = Double.random(in: 0.5...1)
        return UInt64(seconds * 1_000_000_000)
    }
}
