
struct AxeTrick: GameTrick {
    let type = TrickType.axe
    let icon = "🪓"
    let name = "Axel"
    let message = "Target halved!"
    let description = "Each turn, the Target value is halved."
    let duration: Int
    let probability: Double
    
    @MainActor
    func triggerOnTurn(to state: GameState) async -> Bool {
        let newTarget = Numbers.clip(state.targetNumber / 2)
        state.targetNumber = newTarget
        return true
    }
}
