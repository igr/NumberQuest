import Foundation

struct ChangeTargetNumberEffect: GameEffect {
    var icon = "🔀"
    var message = "Target Changed!"
    func apply(to game: inout GameManager) {
        // Pick a new random number
        game.targetNumber = Int.random(in: 0...999)
    }
}
