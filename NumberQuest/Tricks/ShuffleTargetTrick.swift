import Foundation

struct ShuffleTargetTrick: GameTrick {
    var type = TrickType.shuffleTarget
    var icon = "🔀"
    var message = "Target Changed!"
    var name = "Shuffle Target"
    var description = "The target number will change to a NEW random number immediately!"
    var duration = 0

    @MainActor
    func triggerOnCreate(to game: GameManager) async {
        game.targetNumber = Int.random(in: 0...999)
    }
}
