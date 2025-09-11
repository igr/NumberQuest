import Foundation

// MARK: - Message Protocol
protocol GameMessage: Identifiable, Equatable {
    var id: UUID { get }
}

// MARK: - Player Message
struct PlayerMessage: GameMessage {
    let id = UUID()
    let guess: Int
    let attempt: Int
    
    init(guess: Int, attempt: Int) {
        self.guess = guess
        self.attempt = attempt
    }
    
    static func == (lhs: PlayerMessage, rhs: PlayerMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - System Message
struct SystemMessage: GameMessage {
    let id = UUID()
    let messageType: SystemMessageType
    
    enum SystemMessageType {
        case welcome
        case tooHigh(currentGuess: Int)
        case tooLow(currentGuess: Int)
        case victory(targetNumber: Int, attempts: Int)
    }
    
    init(type: SystemMessageType) {
        self.messageType = type
    }
    
    static func == (lhs: SystemMessage, rhs: SystemMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Effect Message
struct EffectMessage: GameMessage {
    let id = UUID()
    let effectType: EffectType
    
    enum EffectType {
        case gameStart
        case gameEnd
        case milestone(attempt: Int)
        case celebration
        case warning(message: String)
    }
    
    init(type: EffectType) {
        self.effectType = type
    }
    
    static func == (lhs: EffectMessage, rhs: EffectMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Type-erased Message Container
struct Message: Identifiable, Equatable {
    let id = UUID()
    private let _message: any GameMessage
    
    var isPlayerMessage: Bool { _message is PlayerMessage }
    var isSystemMessage: Bool { _message is SystemMessage }
    var isEffectMessage: Bool { _message is EffectMessage }
    
    // Type-safe unwrapping methods
    var asPlayerMessage: PlayerMessage? { _message as? PlayerMessage }
    var asSystemMessage: SystemMessage? { _message as? SystemMessage }
    var asEffectMessage: EffectMessage? { _message as? EffectMessage }
    
    init(_ message: any GameMessage) {
        self._message = message
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}
