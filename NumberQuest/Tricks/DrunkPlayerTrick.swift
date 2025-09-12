
struct DrunkPlayerTrick: GameTrick {
    var type = TrickType.drunkPlayer
    var icon = "🤪"
    var name = "Drunk Player"
    var message = "Guess is now a bit off..."
    var description = "The next guess is changed by random number between -20 and 20 each turn."
    var duration = 3
    
    func triggerOnGuess(guess: Int) -> Int {
        let offset = Int.random(in: -20...20)
        return Numbers.clip(guess + offset)
    }
}
