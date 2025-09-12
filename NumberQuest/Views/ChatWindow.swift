import SwiftUI
import Foundation
import AudioToolbox

// MARK: - Message Bubble Container
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        if let playerMessage = message.asPlayerMessage {
            PlayerMessageBubble(playerMessage: playerMessage)
        } else if let systemMessage = message.asSystemMessage {
            SystemMessageBubble(systemMessage: systemMessage)
        } else if let trickMessage = message.asTrickMessage {
            TrickMessageBubble(trickMessage: trickMessage)
        }
    }
}

// MARK: - Chat Window Component
struct ChatWindow: View {
    @Binding var messages: [Message]
    @State private var previousMessageCount = 0
    
    private let plopSoundId: SystemSoundID = 1306 // SMS sound - plop effect
    
    var body: some View {
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
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 200)
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
            .onChange(of: messages) { _, newMessages in
                // Play sound when new messages are added
                if newMessages.count > previousMessageCount && previousMessageCount > 0 {
                    AudioServicesPlaySystemSound(plopSoundId)
                }
                previousMessageCount = newMessages.count
                
                // Auto-scroll to bottom when new messages are added
                if let lastMessage = newMessages.last {
                    withAnimation(.easeOut(duration: 0.4)) {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            .onAppear {
                // Initialize message count to prevent sound on first load
                previousMessageCount = messages.count
                
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
        Message(PlayerMessage(guess: 500, attempt: 1)),
        Message(SystemMessage(type: .tooHigh(currentGuess: 500))),
        Message(PlayerMessage(guess: 250, attempt: 2)),
        Message(SystemMessage(type: .tooLow(currentGuess: 250))),
        Message(PlayerMessage(guess: 375, attempt: 3)),
        Message(SystemMessage(type: .tooHigh(currentGuess: 375))),
        Message(PlayerMessage(guess: 312, attempt: 4)),
        Message(TrickMessage(ShuffleTargetTrick())),
        Message(SystemMessage(type: .victory(targetNumber: 312, attempts: 4)))
    ]
}
