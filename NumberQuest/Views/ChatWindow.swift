import SwiftUI
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
    
    init(guess: Int) {
        self.guess = guess
        self.content = "My guess: \(guess)"
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

// MARK: - Type-erased Message Container
struct Message: Identifiable, Equatable {
    let id = UUID()
    private let _message: any GameMessage
    
    var content: String { _message.content }
    var isPlayerMessage: Bool { _message is PlayerMessage }
    
    init(_ message: any GameMessage) {
        self._message = message
    }
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Individual Message View
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isPlayerMessage {
                Spacer()
            }
            
            // Message bubble
            Text(message.content)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(message.isPlayerMessage ? Color.green : Color.blue)
                )
                .frame(maxWidth: 280, alignment: message.isPlayerMessage ? .trailing : .leading)
            
            if !message.isPlayerMessage {
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Chat Window Component
struct ChatWindow: View {
    @Binding var messages: [Message]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        if messages.isEmpty {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "message")
                                    .font(.system(size: 48))
                                    .foregroundColor(.secondary)
                                
                                Text("No messages yet")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text("Messages will appear here as you play")
                                    .font(.subheadline)
                                    .foregroundColor(. black)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(minHeight: geometry.size.height * 0.6)
                        } else {
                            // Message list
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom)
                                            .combined(with: .opacity)
                                            .animation(.easeOut(duration: 0.3)),
                                        removal: .opacity.animation(.easeIn(duration: 0.2))
                                    ))
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: messages) { _ in
                    // Auto-scroll to bottom when new messages are added
                    if let lastMessage = messages.last {
                        withAnimation(.easeOut(duration: 0.4)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    // Scroll to bottom when view appears
                    if let lastMessage = messages.last {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct ChatWindow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with messages
            ChatWindow(messages: .constant(sampleMessages))
                .previewDisplayName("With Messages")
            
            // Preview with empty state
            ChatWindow(messages: .constant([]))
                .previewDisplayName("Empty State")
            
            // Preview in dark mode
            ChatWindow(messages: .constant(sampleMessages))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
        .previewLayout(.fixed(width: 375, height: 600))
    }
    
    static var sampleMessages: [Message] = [
        Message(SystemMessage(type: .welcome)),
        Message(PlayerMessage(guess: 500)),
        Message(SystemMessage(type: .tooHigh(currentGuess: 500))),
        Message(PlayerMessage(guess: 250)),
        Message(SystemMessage(type: .tooLow(currentGuess: 250))),
        Message(PlayerMessage(guess: 375)),
        Message(SystemMessage(type: .tooHigh(currentGuess: 375))),
        Message(PlayerMessage(guess: 312)),
        Message(SystemMessage(type: .victory(targetNumber: 312, attempts: 4)))
    ]
}
