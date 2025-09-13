import SwiftUI
import PopupView

struct TrickBubble: View {
    let trickMessage: TrickMessage
    @State private var selectedTrick: ActiveTrick?
    
    private var trickColor: Color {
        return .yellow
    }
    private var trickText: String {
        return trickMessage.trick.message
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                selectedTrick = ActiveTrick(trick: trickMessage.trick, remainingDuration: 0)
            }) {
                Text(trickMessage.trick.icon)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
            }
            .buttonStyle(PlainButtonStyle())
            
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
        .trickPopup(item: $selectedTrick) { item in
            TrickDetailView(activeTrick: item)
        }
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
