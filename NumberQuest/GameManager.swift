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
        
        Task {
            // Show the player message immediately
            await MainActor.run {
                // Add player message
                chatMessages.append(Message(PlayerMessage(guess: guess, attempt: attempts)))
            }
            
            // Wait 0.5s before responding
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            if guess == targetNumber {
                await MainActor.run {
                    gameWon = true
                    chatMessages.append(Message(SystemMessage(type: .victory(targetNumber: targetNumber, attempts: attempts))))
                    thinking = false
                }
            } else {
                await MainActor.run {
                    if guess < targetNumber {
                        chatMessages.append(Message(SystemMessage(type: .tooLow(currentGuess: guess))))
                    } else {
                        chatMessages.append(Message(SystemMessage(type: .tooHigh(currentGuess: guess))))
                    }
                    thinking = false
                }
            }
        }
    }
}
