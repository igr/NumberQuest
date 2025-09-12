
struct SnailTrick: GameTrick {
    var type = TrickType.snail
    var icon = "🐌"
    var name = "Snail"
    var message = "Target changed by ONE!"
    var description = "Target changes by ONE each turn."
    var duration = 3

    @MainActor
    func triggerOnTurn(to state: GameState) async {
        let change = Bool.random() ? 1 : -1
        let newTarget = Numbers.clip(state.targetNumber + change)
        state.targetNumber = newTarget
    }
}
