import SwiftUI
import PopupView



struct TrickBubble: View {
    let trickMessage: TrickMessage
    
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTrick: AnyGameTrick?
    
    private var trickColor: Color {
        return Color.theme.bubbleTrick
    }
    private var trickText: String {
        return trickMessage.trick.message
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                selectedTrick = AnyGameTrick(trickMessage.trick)
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
            TrickDetailView(trick: item.trick)
        }
    }
}

#Preview("Shuffle Target") {
    TrickBubble(trickMessage: TrickMessage(AllTricks.tricks[1]))
}
#Preview("Noop Trick") {
    TrickBubble(trickMessage: TrickMessage(AllTricks.tricks[0]))
}
