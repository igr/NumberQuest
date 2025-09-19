
struct SnailTrick: GameTrick {
    var type = TrickType.snail
    var icon = "🐌"
    var name = "Snail"
    var message = "Target changes by 1!"
    var description = "Each turn, Target changes by one in random direction."
    var duration = 3

    @MainActor
    func triggerOnTurn(to state: GameState) async -> Bool {
        let change = Bool.random() ? 1 : -1
        let newTarget = Numbers.clip(state.targetNumber + change)
        state.targetNumber = newTarget
        return true
    }
}
