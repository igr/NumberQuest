import SwiftUI
import Foundation

struct EffectMessageBubble: View {
    let effectMessage: EffectMessage
    
    // Different colors based on effect type
    private var effectColor: Color {
        switch effectMessage.effectType {
        case .gameStart, .gameEnd:
            return .purple
        case .milestone:
            return .red
        case .celebration:
            return .orange
        case .warning:
            return .yellow
        }
    }
    private var effectText: String {
        switch effectMessage.effectType {
        case .gameStart, .gameEnd:
            return "Game started"
        case .celebration:
            return "You did it!"
        case .milestone:
            return "You completed attempts!"
        case .warning:
            return "Warning: Your progress is being saved!"
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 2) {
                Text(effectText)
                    .foregroundColor(.primary)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .italic()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(effectColor.opacity(0.2))
                    .stroke(effectColor.opacity(0.5), lineWidth: 1)
            )
            .frame(maxWidth: 250)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    
}
