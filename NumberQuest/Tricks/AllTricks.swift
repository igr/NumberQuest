import Foundation

enum TrickType: CaseIterable {
    case noop
    case shuffleTarget
    case snail
    case linguaLarry
    case drunkPlayer
    case expandSlots
    case magnet
    case killBill
    case mirror
    case doubleOhSeven
    case runner
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
    
    /// Applies trick to the game manager right after choosing the trick, returns true if activated
    func triggerOnCreate(to state: GameState) async -> Bool
    /// Applies trick effect on each turn while active, returns true if active
    func triggerOnTurn(to state: GameState) async -> Bool
    /// Hook to allow tricks to modify system messages, returns value if changed
    func triggerOnShowMiss(systemMessage: SystemMessage) -> SystemMessage?
    /// Applies trick on the guess before it is used in the game, returns value if changed
    func triggerOnGuess(target: Int, guess: Int) -> Int?
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
    
    func triggerOnCreate(to state: GameState) -> Bool { return false }
    func triggerOnTurn(to state: GameState) -> Bool { return false }
    func triggerOnShowMiss(systemMessage: SystemMessage) -> SystemMessage? { return nil }
    func triggerOnGuess(target: Int, guess: Int) -> Int? { return nil }
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
            probability: 10.0,
            builder: { NoopTrick() }
        ),
        TrickDefinition(
            type: .shuffleTarget,
            probability: 0.5,
            builder: { ShuffleTargetTrick() }
        ),
        TrickDefinition(
            type: .snail,
            probability: 5.0,
            builder: { SnailTrick(duration: 3) }
        ),
        TrickDefinition(
            type: .linguaLarry,
            probability: 4.0,
            builder: { LinguaLarryTrick(duration: 1) }
        ),
        TrickDefinition(
            type: .drunkPlayer,
            probability: 5.0,
            builder: { DrunkPlayerTrick(duration: 3) }
        ),
        TrickDefinition(
            type: .magnet,
            probability: 5.0,
            builder: { MagnetTrick(duration: 2) }
        ),
        TrickDefinition(
            type: .killBill,
            probability: 2.0,
            builder: { KillBillTrick() }
        ),
        TrickDefinition(
            type: .mirror,
            probability: 2.0,
            builder: { MirrorTrick(duration: 1) }
        ),
        TrickDefinition(
            type: .doubleOhSeven,
            probability: 1.0,
            builder: { DoubleOhSevenTrick(duration: 1) }
        ),
        TrickDefinition(
            type: .runner,
            probability: 5.0,
            builder: { RunnerTrick(duration: 2) }
        ),
    ]
    
    // MARK: - Probability
    static func calcTrickProbability(_ activeTrick: ActiveTrick) -> (Int, Int) {
        // Find the trick definition for this active trick
        guard let trickDef = tricks.first(where: { $0.type == activeTrick.type }) else {
            return (0, 0) // Trick not found
        }
        
        // Calculate total probability of all tricks
        let totalProbability = tricks.reduce(0) { $0 + $1.probability }
        
        // Return as integers (converting from Double)
        var trickProbability = trickDef.probability
        var factor = 1.0
        if (trickProbability < 1) {
            factor = 1 / trickProbability
            trickProbability = 1.0
        }
        let totalProbabilityInt = Int(totalProbability * factor)
        
        return (Int(trickProbability), totalProbabilityInt)
    }
    
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
