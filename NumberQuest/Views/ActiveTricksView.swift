import SwiftUI
import PopupView

struct ActiveTricksView: View {
    let activeTricks: [ActiveTrick]
    let attemptCount: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack(alignment: .center, spacing: 8) {
                // split activeTricks into chunks of max 3 per line
                ForEach(Array(activeTricks.chunked(into: 3).enumerated()), id: \.offset) { _, row in
                    HStack(alignment: .center, spacing: 8) {
                        ForEach(row.indices, id: \.self) { index in
                            let activeTrick = row[index]
                            TrickView(
                                activeTrick: activeTrick,
                                rotationAngle: index.isMultiple(of: 2) ? 5 : -5
                            ) {
                                // Action can be empty or used for other purposes
                            }
                        }
                    }
                }
            }
            // Attempt count circle on the right
            Text("\(attemptCount)")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle().fill(Color.theme.attempt)
                )
            
        }
    }
}


#Preview {
    ActiveTricksView(activeTricks: [
        ActiveTrick(trick: AllTricks.tricks[1], remainingDuration: 5),
        ActiveTrick(trick: AllTricks.tricks[2], remainingDuration: 1),
        ActiveTrick(trick: AllTricks.tricks[3], remainingDuration: 4),
        ActiveTrick(trick: AllTricks.tricks[4], remainingDuration: 4),
        ActiveTrick(trick: AllTricks.tricks[5], remainingDuration: 4),
    ], attemptCount: 7)
}

#Preview("Two") {
    ActiveTricksView(activeTricks: [
        ActiveTrick(trick: AllTricks.tricks[1], remainingDuration: 5),
        ActiveTrick(trick: AllTricks.tricks[2], remainingDuration: 1),
    ], attemptCount: 7)
}


#Preview("With Attempts Only") {
    ActiveTricksView(activeTricks: [], attemptCount: 3)
}

#Preview("TrickDetailView") {
    TrickDetailView(activeTrick: ActiveTrick(trick: AllTricks.tricks[1], remainingDuration: 2))
}
