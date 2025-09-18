import Foundation

struct KillBillTrick: GameTrick {
    var type = TrickType.killBill
    var icon = "⚔️"
    var name = "Kill Bill"
    var message = "Active Trick killed!"
    var description = "The first of active tricks is removed permanently."
    var duration = 0

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        if state.activeTricks.isEmpty { return false }
        state.activeTricks.removeFirst()
        return true
    }
}
