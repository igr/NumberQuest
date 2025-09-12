import Foundation

enum TrickType: CaseIterable {
    case noop
    case shuffleTarget
    case snail
    case linguaLarry
}

protocol GameTrick: Identifiable, Equatable {
    var id: UUID { get }
    /// Trick type
    var type: TrickType { get }
    /// Trick icon (emoji)
    var icon: String { get }
    /// Trick message that will be shown right away
    var message: String { get }
    /// Trick name
    var name: String { get }
    /// Trick description
    var description: String { get }
    
    /// How many cycles trick is active
    var duration: Int { get }
    
    /// Returns true if trick is not really an trick, but a NOOP.
    var isNoop: Bool { get }
    
    /// triggers when trick is created
    func triggerOnCreate(to game: GameManager) async
    /// triggers on each turn
    func triggerOnTurn(to game: GameManager) async
}

extension GameTrick {
    var id: UUID { UUID() }
    var type: TrickType { .noop }
    var icon: String { "X" }
    var name: String { "Trick" }
    var message: String { "Trick in action" }
    var description: String { "Trick description" }
    var duration: Int { Int.max }
    var isNoop: Bool { false }
    
    /// Applies trick to the game manager right after choosing the trick
    func triggerOnCreate(to game: GameManager) {}
    
    /// Applies trick effect on each turn while active
    func triggerOnTurn(to game: GameManager) {}
}

/// Represents a single trick configuration:
/// - probability: chance that the trick is chosen
/// - builder: function that creates the trick
struct TrickDefinition {
    let type: TrickType
    let probability: Double    
    let builder: () -> any GameTrick
}

enum AllTricks {
    // MARK: - Registry of all tricks
    static let tricks: [TrickDefinition] = [
        TrickDefinition(
            type: .noop,
            probability: 1.0,
            builder: { NoopTrick() }
        ),
        TrickDefinition(
            type: .shuffleTarget,
            probability: 1.0,
            builder: { ShuffleTargetTrick() }
        ),
        TrickDefinition(
            type: .snail,
            probability: 1.0,            
            builder: { SnailTrick() }
        ),
        TrickDefinition(
            type: .linguaLarry,
            probability: 1.0,
            builder: { LinguaLarryTrick() }
        )
    ]
    
    // MARK: - Returns a random trick excluding active tricks
    static func randomTrick(excluding activeTricks: [ActiveTrick]) -> any GameTrick {
        guard !tricks.isEmpty else { fatalError("No tricks available") }
        
        // Get types of currently active tricks
        let activeTrickTypes = Set(activeTricks.map { $0.type })
        
        // Filter out tricks that are currently active
        let availableTricks = tricks.filter { trickDef in
            return !activeTrickTypes.contains(trickDef.type)
        }
        
        // If no tricks available (all are active)
        guard !availableTricks.isEmpty else {
            return NoopTrick()
        }
        
        let totalWeight = availableTricks.reduce(0) { $0 + $1.probability }
        let random = Double.random(in: 0..<totalWeight)
        
        var running = 0.0
        for trick in availableTricks {
            running += trick.probability
            if random < running {
                return trick.builder()
            }
        }
        return availableTricks.last!.builder() // fallback
    }
}

struct ActiveTrick : Identifiable, Equatable {
    let id = UUID()
    let trick: any GameTrick
    var type: TrickType { trick.type }
    var remainingDuration: Int
    
    static func == (lhs: ActiveTrick, rhs: ActiveTrick) -> Bool {
        lhs.id == rhs.id
    }
}
