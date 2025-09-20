import Foundation

struct ShuffleTargetTrick: GameTrick {
    var type = TrickType.shuffleTarget
    var icon = "🔀"
    var name = "Shuffle Target"
    var message = "Target changed!"
    var description = "The target number is replaced with a new random number permanently."
    var duration = 0

    @MainActor
    func triggerOnCreate(to state: GameState) async -> Bool {
        state.targetNumber = Int.random(in: 0...999)
        return true
    }
}
