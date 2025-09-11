import SwiftUI
import Foundation

// MARK: - Player Message Bubble
struct PlayerMessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(message.content)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.green)
                )
                .frame(maxWidth: 280, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - System Message Bubble
struct SystemMessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            Text(message.content)
                .foregroundColor(.white)
                .font(.body)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.blue)
                )
                .frame(maxWidth: 280, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Effect Message Bubble
struct EffectMessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(message.content)
                .foregroundColor(.primary)
                .font(.callout)
                .fontWeight(.semibold)
                .italic()
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.orange.opacity(0.2))
                        .stroke(Color.orange.opacity(0.5), lineWidth: 1)
                )
                .frame(maxWidth: 250)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Message Bubble Container
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        if message.isPlayerMessage {
            PlayerMessageBubble(message: message)
        } else if message.isSystemMessage {
            SystemMessageBubble(message: message)
        } else if message.isEffectMessage {
            EffectMessageBubble(message: message)
        }
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
        Message(EffectMessage(type: .gameStart)),
        Message(SystemMessage(type: .welcome)),
        Message(PlayerMessage(guess: 500, attempt: 1)),
        Message(SystemMessage(type: .tooHigh(currentGuess: 500))),
        Message(PlayerMessage(guess: 250, attempt: 2)),
        Message(SystemMessage(type: .tooLow(currentGuess: 250))),
        Message(EffectMessage(type: .encouragement)),
        Message(PlayerMessage(guess: 375, attempt: 3)),
        Message(SystemMessage(type: .tooHigh(currentGuess: 375))),
        Message(PlayerMessage(guess: 312, attempt: 4)),
        Message(EffectMessage(type: .celebration)),
        Message(SystemMessage(type: .victory(targetNumber: 312, attempts: 4)))
    ]
}
