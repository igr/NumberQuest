import Foundation

struct ExpandSlotsTrick: GameTrick {
    var type = TrickType.expandSlots
    var icon = "🚥"
    var name = "Expand Slots"
    var message = "Number of Trick slots increased!"
    var description = "The number of Trick slots is increased by one."
    var duration = 0

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        state.maxActiveTricks += 1
        return true
    }
}
