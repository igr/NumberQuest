
///
struct SnailTrick: GameTrick {
    var icon = "🐌"
    var name = "Snail"
    var message = "Target Changed!"
    var description = "Target changes by ONE on each turn."
    var duration = 0
    
    func apply(to game: inout GameManager) {
        // Pick a new random number
        game.targetNumber = Int.random(in: 0...999)
    }
}
