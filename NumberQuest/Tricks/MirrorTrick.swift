
struct MirrorTrick: GameTrick {
    var type = TrickType.mirror
    var icon = "🪞"
    var name = "Mirror"
    var message = "Guess digits flipped!"
    var description = "Each turn, the Guess digits flip their order before being sent."
    var duration = 1
    
    init(duration: Int) {
        self.duration = duration
    }
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let reversedGuess = String(String(format: "%03d", guess).reversed())
        return Int(reversedGuess) ?? guess
    }
}
