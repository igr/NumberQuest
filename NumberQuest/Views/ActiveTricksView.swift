import SwiftUI
import PopupView

struct ActiveTricksView: View {
    let activeTricks: [ActiveTrick]
    let attemptCount: Int
    @State var selectedTrick: ActiveTrick?
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .center, spacing: 8) {
                // split activeTricks into chunks of max 3 per line
                ForEach(Array(activeTricks.chunked(into: 3).enumerated()), id: \.offset) { _, row in
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(row.indices, id: \.self) { index in
                            let activeTrick = row[index]
                            Button(action: {
                                selectedTrick = activeTrick
                            }) {
                                Text(activeTrick.trick.icon)
                                    .font(.title2)
                                Text("\(activeTrick.remainingDuration)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black.opacity(0.6))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill( Color.theme.trickAction.opacity(0.6))
                                    )
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.theme.trickAction.opacity(0.3))
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            // Attempt count circle on the left
            Text("\(attemptCount)")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle().fill(Color.theme.attempt)
                )
            
        }
        .trickPopup(item: $selectedTrick) { item in
            TrickDetailView(activeTrick: item)
        }
    }
}


#Preview {
    ActiveTricksView(activeTricks: [
        ActiveTrick(trick: SnailTrick(), remainingDuration: 5),
        ActiveTrick(trick: ShuffleTargetTrick(), remainingDuration: 1),
        ActiveTrick(trick: LinguaLarryTrick(), remainingDuration: 4),
        ActiveTrick(trick: DrunkPlayerTrick(), remainingDuration: 4),
        ActiveTrick(trick: ExpandSlotsTrick(), remainingDuration: 4),
    ], attemptCount: 7)
}

#Preview("Two") {
    ActiveTricksView(activeTricks: [
        ActiveTrick(trick: SnailTrick(), remainingDuration: 5),
        ActiveTrick(trick: ShuffleTargetTrick(), remainingDuration: 1),
    ], attemptCount: 7)
}


#Preview("With Attempts Only") {
    ActiveTricksView(activeTricks: [], attemptCount: 3)
}

#Preview("TrickDetailView") {
    TrickDetailView(activeTrick: ActiveTrick(trick: SnailTrick(), remainingDuration: 2))
}
