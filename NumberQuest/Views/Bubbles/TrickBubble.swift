import SwiftUI
import Foundation

struct TrickBubble: View {
    let trickMessage: TrickMessage
    
    private var trickColor: Color {
        return .yellow
    }
    private var trickText: String {
        return trickMessage.trick.message
    }
    
    var body: some View {
        HStack {
            Text(trickMessage.trick.icon)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
            VStack(spacing: 2) {
                Text(trickText)
                    .foregroundColor(.primary)
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(trickColor.opacity(0.2))
                    .stroke(trickColor.opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
    }
    
    
}
