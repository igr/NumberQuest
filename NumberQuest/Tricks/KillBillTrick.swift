import Foundation

struct KillBillTrick: GameTrick {
    var type = TrickType.killBill
    var icon = "⚔️"
    var name = "Kill Bill"
    var message = "Active Trick killed!"
    var description = "The first of active tricks is removed."
    var duration = 0

    @MainActor
    func triggerOnCreate(to state: GameState) async {
        if state.activeTricks.isEmpty { return }
        state.activeTricks.removeFirst()
    }
}
