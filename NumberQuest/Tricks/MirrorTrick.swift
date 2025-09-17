
struct MirrorTrick: GameTrick {
    var type = TrickType.mirror
    var icon = "🪞"
    var name = "Mirror"
    var message = "Digits are reflected!"
    var description = "The order of the digits is reversed when you guess."
    var duration = 3
    
    func triggerOnGuess(guess: Int) -> Int {
        let reversedString = String(String(guess).reversed())
        return Int(reversedString) ?? guess
    }
}
