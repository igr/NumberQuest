import Foundation

enum TrickType: String, CaseIterable {
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

extension TrickType {
    var asString: String {
        return self.rawValue
    }
    static func fromString(_ string: String) -> TrickType? {
        return TrickType(rawValue: string)
    }
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

    /// Probability
    var probability: Double { get }
    
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
    var probability: Double { 0.0 }
    
    func triggerOnCreate(to state: GameState) -> Bool { return false }
    func triggerOnTurn(to state: GameState) -> Bool { return false }
    func triggerOnShowMiss(systemMessage: SystemMessage) -> SystemMessage? { return nil }
    func triggerOnGuess(target: Int, guess: Int) -> Int? { return nil }
}

// Type-erased wrapper for GameTrick that conforms to Identifiable and Equatable
struct AnyGameTrick: Identifiable, Equatable {
    let id = UUID()
    let trick: any GameTrick
    
    init(_ trick: any GameTrick) {
        self.trick = trick
    }
    
    static func == (lhs: AnyGameTrick, rhs: AnyGameTrick) -> Bool {
        lhs.id == rhs.id
    }
}

struct ActiveTrick : Identifiable, Equatable {
    let id = UUID()
    let trick: any GameTrick
    var remainingDuration: Int
    
    static func == (lhs: ActiveTrick, rhs: ActiveTrick) -> Bool {
        lhs.id == rhs.id
    }
}

enum AllTricks {
    // MARK: - Registry of all tricks
    static let tricks: [any GameTrick] = [
        NoopTrick(probability: 10.0),
        ShuffleTargetTrick(probability: 0.5),
        SnailTrick(duration: 3, probability: 5.0),
        LinguaLarryTrick(duration: 1, probability: 4.0),
        DrunkPlayerTrick(duration: 3, probability: 5.0),
        MagnetTrick(duration: 2, probability: 5.0),
        KillBillTrick(probability: 2.0),
        MirrorTrick(duration: 1, probability: 2.0),
        DoubleOhSevenTrick(duration: 1, probability: 1.0),
        RunnerTrick(duration: 2, probability: 5.0),
        ExpandSlotsTrick(probability: 1.0),
    ]
    
    // MARK: - Probability in percentages
    static func calcTrickProbability(_ activeTrick: any GameTrick) -> Double {
        // Find the trick definition for this active trick
        guard let trickDef = tricks.first(where: { $0.type == activeTrick.type }) else {
            return 0 // Trick not found
        }
        
        // Calculate total probability of all tricks
        let totalProbability = tricks.reduce(0) { $0 + $1.probability }
        let trickProbability = trickDef.probability
        
        return totalProbability > 0 ? (trickProbability / totalProbability) * 100 : 0
    }
    
    // MARK: - Returns a random trick excluding active tricks
    static func randomTrick(excluding activeTricks: [ActiveTrick]) -> any GameTrick {
        guard !tricks.isEmpty else { fatalError("No tricks available") }
        
        // Get types of currently active tricks
        let activeTrickTypes = Set(activeTricks.map { $0.trick.type })
        
        // Filter out tricks that are currently active
        let availableTricks = tricks.filter { trickDef in
            return !activeTrickTypes.contains(trickDef.type)
        }
        
        // If no tricks available (all are active)
        guard !availableTricks.isEmpty else {
            return tricks.first!
        }
        
        let totalWeight = availableTricks.reduce(0) { $0 + $1.probability }
        let random = Double.random(in: 0..<totalWeight)
        
        var running = 0.0
        for trick in availableTricks {
            running += trick.probability
            if random < running {
                return trick
            }
        }
        return availableTricks.last! // fallback
    }
}
