import Foundation

// MARK: - Message Protocol
protocol GameMessage: Identifiable, Equatable {
    var id: UUID { get }
    var content: String { get }
}

// MARK: - Player Message
struct PlayerMessage: GameMessage {
    let id = UUID()
    let content: String
    let guess: Int
    let attempt: Int
    
    init(guess: Int, attempt: Int) {
        self.guess = guess
        self.attempt = attempt
        self.content = "Attempt #\(attempt): \(guess)"
    }
    
    static func == (lhs: PlayerMessage, rhs: PlayerMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - System Message
struct SystemMessage: GameMessage {
    let id = UUID()
    let content: String
    let messageType: SystemMessageType
    
    enum SystemMessageType {
        case welcome
        case tooHigh(currentGuess: Int)
        case tooLow(currentGuess: Int)
        case victory(targetNumber: Int, attempts: Int)
        case hint(message: String)
    }
    
    init(type: SystemMessageType) {
        self.messageType = type
        
        switch type {
        case .welcome:
            self.content = "🎯 Welcome to NumberQuest! I'm thinking of a 3-digit number. Can you guess it?"
        case .tooHigh(let guess):
            self.content = "📉 Too high! \(guess) is greater than my number."
        case .tooLow(let guess):
            self.content = "📈 Too low! \(guess) is less than my number."
        case .victory(let target, let attempts):
            self.content = "🎉 Congratulations! You guessed \(target) in \(attempts) attempt\(attempts == 1 ? "" : "s")!"
        case .hint(let message):
            self.content = "💡 \(message)"
        }
    }
    
    static func == (lhs: SystemMessage, rhs: SystemMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Effect Message
struct EffectMessage: GameMessage {
    let id = UUID()
    let content: String
    let effectType: EffectType
    let duration: TimeInterval
    
    enum EffectType {
        case gameStart
        case gameEnd
        case milestone(attempt: Int)
        case streak(count: Int)
        case celebration
        case encouragement
        case warning(message: String)
    }
    
    init(type: EffectType, duration: TimeInterval = 3.0) {
        self.effectType = type
        self.duration = duration
        
        switch type {
        case .gameStart:
            self.content = "✨ New game started!"
        case .gameEnd:
            self.content = "🏁 Game ended"
        case .milestone(let attempt):
            self.content = "🎖️ Milestone reached - \(attempt) attempts!"
        case .streak(let count):
            self.content = "🔥 \(count) game winning streak!"
        case .celebration:
            self.content = "🎊 Amazing guess!"
        case .encouragement:
            self.content = "💪 Keep trying! You're getting closer!"
        case .warning(let message):
            self.content = "⚠️ \(message)"
        }
    }
    
    static func == (lhs: EffectMessage, rhs: EffectMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Type-erased Message Container
struct Message: Identifiable, Equatable {
    let id = UUID()
    private let _message: any GameMessage
    
    var content: String { _message.content }
    var isPlayerMessage: Bool { _message is PlayerMessage }
    var isSystemMessage: Bool { _message is SystemMessage }
    var isEffectMessage: Bool { _message is EffectMessage }
    
    init(_ message: any GameMessage) {
        self._message = message
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}