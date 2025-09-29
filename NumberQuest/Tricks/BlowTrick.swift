
struct BlowTrick: GameTrick {
    let type = TrickType.blow
    let icon = "🎈"
    let name = "Balloon"
    let message = "Guess doubled!"
    let description = "Each turn, the Guess value is doubled."
    let duration: Int
    let probability: Double
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let doubleGuess = Double(guess) * 2
        return Numbers.clip(Int(doubleGuess))
    }
}
