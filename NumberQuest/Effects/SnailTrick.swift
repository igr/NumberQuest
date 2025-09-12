
///
struct SnailTrick: GameTrick {
    var icon = "🐌"
    var name = "Snail"
    var message = "Target Changed!"
    var description = "Target changes by ONE on each turn."
    var duration = 10
    
    func triggerOnCreate(to game: GameManager) {
        // Pick a new random number
        game.targetNumber = Int.random(in: 0...999)
    }
}
