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
        case .streak:
            return .red
        case .celebration:
            return .pink
        case .encouragement:
            return .orange
        case .warning:
            return .yellow
        }
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 2) {
                Text(effectMessage.content)
                    .foregroundColor(.primary)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .italic()
                
                // Show effect type for debugging/context
                Text("effect · \(String(format: "%.1f", effectMessage.duration))s")
                    .foregroundColor(.secondary)
                    .font(.caption2)
                    .fontWeight(.light)
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
