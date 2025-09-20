
struct DrunkPlayerTrick: GameTrick {
    var type = TrickType.drunkPlayer
    var icon = "🤪"
    var name = "Drunk Player"
    var message = "Guess changed a bit."
    var description = "Each turn, the Guess changes by a random number between -10 and 10."
    var duration = 3
    
    init(duration: Int) {
        self.duration = duration
    }
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let offset = Int.random(in: -10...10)
        return Numbers.clip(guess + offset)
    }
}
