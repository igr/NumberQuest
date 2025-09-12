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
        HStack(spacing: 4) {
            Text(trickMessage.trick.icon)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
            Text(trickText)
                .foregroundColor(.primary)
                .font(.callout)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(trickColor.opacity(0.2))
                .stroke(trickColor.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    TrickBubble(trickMessage: TrickMessage(SnailTrick()))
}
#Preview("Shuffle Target") {
    TrickBubble(trickMessage: TrickMessage(ShuffleTargetTrick()))
}
#Preview("Noop Trick") {
    TrickBubble(trickMessage: TrickMessage(NoopTrick()))
}
