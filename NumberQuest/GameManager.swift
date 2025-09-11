import Foundation

class GameManager: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var message: String = "Make your first guess!"
    @Published var gameStarted: Bool = false
    @Published var chatMessages: [Message] = []
    
    func startNewGame() {
        targetNumber = Int.random(in: 1...999)
        attempts = 0
        gameWon = false
        gameStarted = true
        message = "I'm thinking of a 3-digit number. Can you guess it?"
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
            message = "🎉 Congratulations! You guessed \(targetNumber) in \(attempts) attempts!"
            chatMessages.append(Message(SystemMessage(type: .victory(targetNumber: targetNumber, attempts: attempts))))
        } else {
            if guess < targetNumber {
                message = "📈 Too low! Try a higher number."
                chatMessages.append(Message(SystemMessage(type: .tooLow(currentGuess: guess))))
            } else {
                message = "📉 Too high! Try a lower number."
                chatMessages.append(Message(SystemMessage(type: .tooHigh(currentGuess: guess))))
            }
        }
    }
}
