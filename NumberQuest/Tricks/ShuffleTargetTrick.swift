import Foundation

struct ShuffleTargetTrick: GameTrick {
    var type = TrickType.shuffleTarget
    var icon = "🔀"
    var name = "Shuffle Target"
    var message = "Target Changed!"
    var description = "The target number will change to a NEW random number immediately!"
    var duration = 0

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        state.targetNumber = Int.random(in: 0...999)
        return true
    }
}
