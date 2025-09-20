

struct DoubleOhSevenTrick: GameTrick {
    var type = TrickType.doubleOhSeven
    var icon = "🕵️‍♀️"
    var name = "007"
    var message = "One 7 turns to Target."
    var description = "Each turn, last digit 7 is turned into the Target digit."
    var duration = 1
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        var digits = Array(String(guess))
        if let idx = digits.lastIndex(of: "7") {
            digits[idx] = Character(String(target))
            return Int(String(digits))
        }
        return nil
    }
}
