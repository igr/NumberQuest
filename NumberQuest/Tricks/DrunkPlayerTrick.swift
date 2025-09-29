
struct DrunkPlayerTrick: GameTrick {
    let type = TrickType.drunkPlayer
    let icon = "🤪"
    let name = "Drunk Player"
    let message = "Guess changed a bit."
    let description = "Each turn, the Guess changes by a random number between -10 and 10."
    let duration: Int
    let probability: Double
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let offset = Int.random(in: -10...10)
        return Numbers.clip(guess + offset)
    }
}
