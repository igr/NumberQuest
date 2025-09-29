
struct AxeTrick: GameTrick {
    let type = TrickType.axe
    let icon = "🪓"
    let name = "Axel"
    let message = "Guess halved!"
    let description = "Each turn, the Guess value is halved."
    let duration: Int
    let probability: Double
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let halvedGuess = Double(guess) / 2
        return Int(halvedGuess)
    }
}
