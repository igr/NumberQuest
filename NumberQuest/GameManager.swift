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
    func makeGuess(firstDigit: Int, secondDigit: Int, thirdDigit: Int) {
        let guess = firstDigit * 100 + secondDigit * 10 + thirdDigit
        attempts += 1
        
        if guess == targetNumber {
            gameWon = true
            message = "🎉 Congratulations! You guessed \(targetNumber) in \(attempts) attempts!"
        } else {
            // Provide hints about which digits are correct
            let targetDigits = getDigits(from: targetNumber)
            let guessDigits = [firstDigit, secondDigit, thirdDigit]
            
            var correctPositions = 0
            var correctDigits = 0
            
            // Check correct positions
            for i in 0..<3 {
                if guessDigits[i] == targetDigits[i] {
                    correctPositions += 1
                }
            }
            
            // Check correct digits in wrong positions
            var targetCount = [Int: Int]()
            var guessCount = [Int: Int]()
            
            for digit in targetDigits {
                targetCount[digit, default: 0] += 1
            }
            
            for digit in guessDigits {
                guessCount[digit, default: 0] += 1
            }
            
            for digit in 0...9 {
                correctDigits += min(targetCount[digit, default: 0], guessCount[digit, default: 0])
            }
            
            let wrongPosition = correctDigits - correctPositions
            
            if guess < targetNumber {
                message = "📈 Too low! \(correctPositions) digits in correct position, \(wrongPosition) correct digits in wrong position."
            } else {
                message = "📉 Too high! \(correctPositions) digits in correct position, \(wrongPosition) correct digits in wrong position."
            }
        }
    }
    
    private func getDigits(from number: Int) -> [Int] {
            let hundreds = number / 100
            let tens = (number % 100) / 10
            let units = number % 10
            return [hundreds, tens, units]
        }
}
