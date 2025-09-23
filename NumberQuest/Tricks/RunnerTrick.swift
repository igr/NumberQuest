
struct RunnerTrick: GameTrick {
    var type = TrickType.runner
    var icon = "🏃‍♂️"
    var name = "Runner"
    var message = "Target runs away from Guess."
    var description = "Each turn, the Target moves 10 away from the Guess."
    var duration = 2
    
    init(duration: Int) {
        self.duration = duration
    }

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

