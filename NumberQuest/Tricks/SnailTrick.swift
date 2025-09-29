
struct SnailTrick: GameTrick {
    let type = TrickType.snail
    let icon = "🐌"
    let name = "Snail"
    let message = "Target changed by 1."
    let description = "Each turn, the Target moves by one in a random direction."
    let duration: Int
    let probability: Double

    @MainActor
    func triggerOnTurn(to state: GameState) async -> Bool {
        let change = Bool.random() ? 1 : -1
        let newTarget = Numbers.clip(state.targetNumber + change)
        state.targetNumber = newTarget
        return true
    }
}
