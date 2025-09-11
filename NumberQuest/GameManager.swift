import Foundation

class GameManager: ObservableObject {
    @Published var targetNumber: Int = 0
    @Published var attempts: Int = 0
    @Published var gameWon: Bool = false
    @Published var message: String = "Make your first guess!"
    @Published var gameStarted: Bool = false
    
    func startNewGame() {
        targetNumber = Int.random(in: 1...999)
        attempts = 0
        gameWon = false
        gameStarted = true
        message = "I'm thinking of a 3-digit number. Can you guess it?"
    }
    func makeGuess(_ guess: Int) {
        attempts += 1
        
        if guess == targetNumber {
            gameWon = true
            message = "🎉 Congratulations! You guessed \(targetNumber) in \(attempts) attempts!"
        } else {
            if guess < targetNumber {
                message = "📈 Too low!"
            } else {
                message = "📉 Too high!"
            }
        }
    }
}
