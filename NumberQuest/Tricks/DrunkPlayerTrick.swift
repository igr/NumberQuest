
struct DrunkPlayerTrick: GameTrick {
    var type = TrickType.drunkPlayer
    var icon = "🤪"
    var name = "Drunk Player"
    var message = "The Guess is a bit off."
    var description = "Each turn, the Guess changes by random number between -20 and 20."
    var duration = 3
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let offset = Int.random(in: -20...20)
        return Numbers.clip(guess + offset)
    }
}
