
struct MirrorTrick: GameTrick {
    var type = TrickType.mirror
    var icon = "🪞"
    var name = "Mirror"
    var message = "Input digits flips!"
    var description = "Each turn, the Guess digits flips order before being sent."
    var duration = 3
    
    func triggerOnGuess(guess: Int) -> Int? {
        let reversedString = String(String(guess).reversed())
        return Int(reversedString) ?? guess
    }
}
