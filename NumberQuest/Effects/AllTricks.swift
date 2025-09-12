import Foundation

protocol GameTrick: Identifiable, Equatable {
    var id: UUID { get }
    /// Trick icon (emoji)
    var icon: String { get }
    /// Trick message that will be shown right away
    var message: String { get }
    /// Trick name
    var name: String { get }
    /// Trick description
    var description: String { get }
    
    /// How many cycles trick is working
    /// Setting to 0 means its an immediate action
    var duration: Int { get }
    
    /// Returns true if trick is not really an trick, but a NOOP.
    var isNoop: Bool { get }
}

extension GameTrick {
    var id: UUID { UUID() }
    var isNoop: Bool { false }
    var icon: String { "X" }
    var name: String { "Trick" }
    var message: String { "Trick in action" }
    var description: String { "Trick description" }
    var duration: Int { Int.max }
    /// Applies trick to the game manager right after choosing the trick
    func apply(to game: GameManager) {}
}

/// Represents a single trick configuration:
/// - probability: chance that the trick is chosen
/// - builder: function that creates the trick
struct TrickDefinition {
    let probability: Double
    let builder: () -> any GameTrick
}

enum AllTricks {
    // MARK: - Registry of all tricks
    static let tricks: [TrickDefinition] = [
        TrickDefinition(
            probability: 1.0,
            builder: { NoopTrick() }
        ),
        TrickDefinition(
            probability: 1.0,
            builder: { ShuffleTargetTrick() }
        ),
        TrickDefinition(
            probability: 1.0,
            builder: { SnailTrick() }
        ),
    ]
    
    // MARK: - Returns a random trick, respecting probabilities
    static func randomTrick() -> any GameTrick {
        guard !tricks.isEmpty else { fatalError("No tricks available") }
        
        let totalWeight = tricks.reduce(0) { $0 + $1.probability }
        let random = Double.random(in: 0..<totalWeight)
        
        var running = 0.0
        for trick in tricks {
            running += trick.probability
            if random < running {
                return trick.builder()
            }
        }
        
        return tricks.last!.builder() // fallback
    }
}
