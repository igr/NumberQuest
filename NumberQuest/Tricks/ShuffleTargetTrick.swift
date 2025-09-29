
struct ShuffleTargetTrick: GameTrick {
    let type = TrickType.shuffleTarget
    let icon = "🔀"
    let name = "Shuffle Target"
    let message = "Target changed!"
    let description = "The target number is replaced with a new random number permanently."
    let duration = 0
    let probability: Double

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        state.targetNumber = Int.random(in: 0...999)
        return true
    }
}
