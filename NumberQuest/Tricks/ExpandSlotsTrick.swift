import Foundation

struct ExpandSlotsTrick: GameTrick {
    let type = TrickType.expandSlots
    let icon = "🚥"
    let name = "Expand Slots"
    let message = "Number of Trick slots increased!"
    let description = "The number of Trick slots is increased by one (permanently)."
    let duration = 0
    let probability: Double

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        state.maxActiveTricks += 1
        return true
    }
}
