import SwiftUI
import Foundation

struct EffectMessageBubble: View {
    let effectMessage: EffectMessage
    
    // Different colors based on effect type
    private var effectColor: Color {
        return .yellow
    }
    private var effectText: String {
        return effectMessage.effect.message
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
