import SwiftUI
import PopupView

struct TrickBubble: View {
    let trickMessage: TrickMessage
    
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTrick: ActiveTrick?
    
    private var trickColor: Color {
        return Color.theme.bubbleTrick
    }
    private var trickText: String {
        return trickMessage.trick.message
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                selectedTrick = ActiveTrick(trick: trickMessage.trick, remainingDuration: trickMessage.trick.duration)
            }) {
                Text(trickMessage.trick.icon)
                    .font(.system(size: 30))
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(trickText)
                .foregroundColor(.primary)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(trickColor.opacity(0.2))
                .stroke(trickColor.opacity(0.5), lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .trickPopup(item: $selectedTrick, colorScheme: colorScheme) { item in
            TrickDetailView(activeTrick: item)
        }
    }
}

#Preview("Shuffle Target") {
    TrickBubble(trickMessage: TrickMessage(ShuffleTargetTrick()))
}
#Preview("Noop Trick") {
    TrickBubble(trickMessage: TrickMessage(NoopTrick()))
}
#Preview("All") {
    VStack {
        TrickBubble(trickMessage: TrickMessage(DoubleOhSevenTrick(duration: 2)))
        TrickBubble(trickMessage: TrickMessage(DrunkPlayerTrick(duration: 2)))
        TrickBubble(trickMessage: TrickMessage(ExpandSlotsTrick()))
        TrickBubble(trickMessage: TrickMessage(KillBillTrick()))
        TrickBubble(trickMessage: TrickMessage(LinguaLarryTrick(duration: 2)))
        TrickBubble(trickMessage: TrickMessage(MagnetTrick(duration: 2)))
        TrickBubble(trickMessage: TrickMessage(ShuffleTargetTrick()))
        TrickBubble(trickMessage: TrickMessage(SnailTrick(duration: 2)))
        TrickBubble(trickMessage: TrickMessage(RunnerTrick(duration: 2)))
    }
}
