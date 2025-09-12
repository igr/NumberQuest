
struct SnailTrick: GameTrick {
    var type = TrickType.snail
    var icon = "🐌"
    var name = "Snail"
    var message = "Target changed by ONE!"
    var description = "Target changes by ONE each turn."
    var duration = 10

    @MainActor
    func triggerOnTurn(to game: GameManager) async {
        // Change target by +1 or -1 randomly each turn
        let change = Bool.random() ? 1 : -1
        let newTarget = max(0, min(999, game.targetNumber + change))
        game.targetNumber = newTarget
    }
}
