import Foundation

class GameManager: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var gameStarted: Bool = false
    @Published var chatMessages: [Message] = []
    
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
        attempts += 1
        
        // Add player message
        chatMessages.append(Message(PlayerMessage(guess: guess, attempt: attempts)))
        
        if guess == targetNumber {
            gameWon = true
            chatMessages.append(Message(SystemMessage(type: .victory(targetNumber: targetNumber, attempts: attempts))))
        } else {
            if guess < targetNumber {
                chatMessages.append(Message(SystemMessage(type: .tooLow(currentGuess: guess))))
            } else {
                chatMessages.append(Message(SystemMessage(type: .tooHigh(currentGuess: guess))))
            }
        }
    }
}
