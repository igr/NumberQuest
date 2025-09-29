import SwiftUI

struct NewTrickBubble: View {
    let trickMessage: NewTrickMessage
    @State private var selectedTrick: ActiveTrick?
    
    private var trickColor: Color {
        return Color.theme.bubbleTrick
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: {
                selectedTrick = ActiveTrick(trick: trickMessage.trick, remainingDuration: trickMessage.trick.duration)
            }) {
                Text("✨ New Trick:")
                    .foregroundColor(.primary)
                    .font(.body.italic())
                Text(trickMessage.trick.name)
                    .foregroundColor(.primary)
                    .font(.headline.bold().italic())
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    NewTrickBubble(trickMessage: NewTrickMessage(
        AllTricks.tricks[2]))
}
