import Foundation

protocol GameEffect: Identifiable, Equatable {
    var id: UUID { get }
    /// Effect icon
    var icon: String { get }
    var message: String { get }
    /// Returns true if effect is not really an effect, but a NOOP.
    var isNoop: Bool { get }
}

extension GameEffect {
    var id: UUID { UUID() }
    var isNoop: Bool { false }
    var icon: String { "X" }
    var message: String { "Effect" }
    
    /// Applies mods to the game manager right after choosing the effect
    func apply(to game: GameManager) {}
}


/// Represents a single effect configuration:
/// - probability: chance that the effect is chosen
/// - builder: function that creates the effect
struct EffectDefinition {
    let probability: Double
    let builder: () -> any GameEffect
}

enum AllEffects {
    // MARK: - Registry of all effects
    static let effects: [EffectDefinition] = [
        EffectDefinition(
            probability: 10.0,
            builder: { NoopEffect() }
        ),
        EffectDefinition(
            probability: 1.0, // 100% chance, only one effect for now
            builder: { ChangeTargetNumberEffect() }
        )
    ]
    
    // MARK: - Returns a random effect, respecting probabilities
    static func randomEffect() -> any GameEffect {
        guard !effects.isEmpty else { fatalError("No effects available") }
        
        let totalWeight = effects.reduce(0) { $0 + $1.probability }
        let random = Double.random(in: 0..<totalWeight)
        
        var running = 0.0
        for effect in effects {
            running += effect.probability
            if random < running {
                return effect.builder()
            }
        }
        
        return effects.last!.builder() // fallback
    }
}
