

struct DoubleOhSevenTrick: GameTrick {
    var type = TrickType.doubleOhSeven
    var icon = "🕵️‍♀️"
    var name = "007"
    var message = "One 7 turns to Target."
    var description = "Each turn, last digit 7 is turned into the Target digit."
    var duration = 1
    
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
