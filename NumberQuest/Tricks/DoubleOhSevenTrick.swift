
struct DoubleOhSevenTrick: GameTrick {
    let type = TrickType.doubleOhSeven
    let icon = "🕵️‍♀️"
    let name = "007"
    let message = "One 7 turned into Target."
    let description = "Each turn, the last digit 7 of the Guess is changed into the Target digit."
    let duration: Int
    let probability: Double
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        var guessDigits = Array(String(guess))
        let targetDigits = Array(String(target))
        if let idx = guessDigits.lastIndex(of: "7") {
            guessDigits[idx] = targetDigits[idx]
            return Int(String(guessDigits))
        }
        return nil
    }
}
