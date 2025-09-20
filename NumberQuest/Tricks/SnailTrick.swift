
struct SnailTrick: GameTrick {
    var type = TrickType.snail
    var icon = "🐌"
    var name = "Snail"
    var message = "Target changed by 1."
    var description = "Each turn, the Target moves by one in a random direction."
    var duration = 3
    
    init(duration: Int) {
        self.duration = duration
    }

    @MainActor
    func triggerOnTurn(to state: GameState) async -> Bool {
        let change = Bool.random() ? 1 : -1
        let newTarget = Numbers.clip(state.targetNumber + change)
        state.targetNumber = newTarget
        return true
    }
}
