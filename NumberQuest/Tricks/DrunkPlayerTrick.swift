
struct DrunkPlayerTrick: GameTrick {
    var type = TrickType.drunkPlayer
    var icon = "🤪"
    var name = "Drunk Player"
    var message = "Guess changed a bit."
    var description = "Each turn, the Guess changes by a random number between -50 and 50."
    var duration = 3
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let offset = Int.random(in: -50...50)
        return Numbers.clip(guess + offset)
    }
}
