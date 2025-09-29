
struct MagnetTrick: GameTrick {
    let type = TrickType.magnet
    let icon = "🧲"
    let name = "Magnet"
    let message = "Target pulled toward the Guess."
    let description = "Each turn, the Target moves towards the Guess by a random distance, but never more than half the remaining distance."
    let duration: Int
    let probability: Double

    @MainActor
    func triggerOnTurn(to state: GameState) async -> Bool {
        // Calculate the difference between target and last guess
        let difference = state.lastGuess - state.targetNumber
        
        // Move target towards the guess by a random amount, but never more than half the difference
        let maxMovement = abs(difference) / 2
        
        // If maxMovement is 0, no movement is possible
        guard maxMovement > 0 else { return false }
        
        // Random movement amount from 1 to maxMovement
        let movement = Int.random(in: 1...maxMovement)
        
        // Determine direction (positive if guess > target, negative if guess < target)
        let direction = difference > 0 ? 1 : -1
        
        // Apply the movement
        let change = movement * direction
        let newTarget = Numbers.clip(state.targetNumber + change)
        state.targetNumber = newTarget
        
        return true
    }
}
