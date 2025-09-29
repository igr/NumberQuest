
struct MirrorTrick: GameTrick {
    let type = TrickType.mirror
    let icon = "🪞"
    let name = "Mirror"
    let message = "Guess digits flipped!"
    let description = "Each turn, the Guess digits flip their order before being sent."
    let duration: Int
    let probability: Double
    
    func triggerOnGuess(target: Int, guess: Int) -> Int? {
        let reversedGuess = String(String(format: "%03d", guess).reversed())
        return Int(reversedGuess) ?? guess
    }
}
