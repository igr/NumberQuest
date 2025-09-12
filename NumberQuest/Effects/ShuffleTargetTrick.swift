import Foundation

struct ShuffleTargetTrick: GameTrick {
    var icon = "🔀"
    var message = "Target Changed!"
    var name = "Shuffle Target"
    var description = "The target number will change to a NEW random number immediately!"
    var duration = 0
    func apply(to game: inout GameManager) {        
        game.targetNumber = Int.random(in: 0...999)
    }
}
