
struct RunnerTrick: GameTrick {
    let type = TrickType.runner
    let icon = "🏃‍♂️"
    let name = "Runner"
    let message = "Target runs away from Guess."
    let description = "Each turn, the Target moves 10 away from the Guess."
    let duration: Int
    let probability: Double

    @MainActor
    func triggerOnTurn(to state: GameState) async -> Bool {
        var newTarget: Int = state.targetNumber
        if state.targetNumber >= state.lastGuess {
            newTarget += 10
        } else {
            newTarget -= 10
        }
        state.targetNumber = Numbers.clip(newTarget)
        return true
    }
}

