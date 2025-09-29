
struct KillBillTrick: GameTrick {
    let type = TrickType.killBill
    let icon = "⚔️"
    let name = "Kill Bill"
    let message = "One active Trick killed!"
    let description = "The first active Trick is removed permanently."
    let duration = 0
    let probability: Double

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        if state.activeTricks.isEmpty { return false }
        state.activeTricks.removeFirst()
        return true
    }
}
