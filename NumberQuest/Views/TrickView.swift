import SwiftUI
import PopupView

struct TrickView: View {
    let activeTrick: ActiveTrick
    let rotationAngle: Double
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var showDetail: ActiveTrick?
    
    var body: some View {
        Button(action: {
            action()
            showDetail = activeTrick
        }) {
            HStack(spacing: 4) {
                Text(activeTrick.trick.icon)
                    .font(.title2)
                if (activeTrick.remainingDuration > 0) {
                    Text("\(activeTrick.remainingDuration)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.theme.trickAction.opacity(0.6))
                        )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.trickAction.opacity(0.3))
        )
        .rotationEffect(.degrees(rotationAngle))
        .trickPopup(item: $showDetail, colorScheme: colorScheme) { item in
            TrickDetailView(trick: item.trick)
        }
    }
}

#Preview {
    TrickView(
        activeTrick: ActiveTrick(
            trick: AllTricks.tricks[2],
            remainingDuration: 5
        ),
        rotationAngle: 5
    ) {
        print("Trick tapped")
    }
    TrickView(
        activeTrick: ActiveTrick(
            trick: AllTricks.tricks[3],
            remainingDuration: 0
        ),
        rotationAngle: -5
    ) {
        print("Trick tapped")
    }
}
