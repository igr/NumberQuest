import SwiftUI
import Foundation

struct SystemMessageBubble: View {
    let systemMessage: SystemMessage
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(systemMessage.content)
                    .foregroundColor(.white)
                    .font(.body)
                
                // Optional: Show message type as subtle indicator
                if case .tooHigh(let guess) = systemMessage.messageType {
                    Text("Your guess: \(guess)")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption2)
                } else if case .tooLow(let guess) = systemMessage.messageType {
                    Text("Your guess: \(guess)")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.caption2)
                }
            }
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
