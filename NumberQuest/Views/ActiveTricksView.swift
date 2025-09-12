import SwiftUI
import PopupView

struct ActiveTricksView: View {
    let activeTricks: [ActiveTrick]
    let attemptCount: Int
    @State var selectedTrick: ActiveTrick?
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Attempt count circle on the left
            Text("\(attemptCount)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color.orange)
                )
            
            ForEach(activeTricks.indices, id: \.self) { index in
                let activeTrick = activeTricks[index]
                Button(action: {
                    selectedTrick = activeTrick
                }) {
                    Text(activeTrick.trick.icon)
                        .font(.title2)
                    Text("\(activeTrick.remainingDuration)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(activeTrick.remainingDuration <= 2 ? Color.red : Color.blue)
                        )
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .popup(item: $selectedTrick) { item in
            TrickDetailView(activeTrick: item)
        } customize: {
            $0
                .type(.floater())
                .closeOnTap(true)
                .appearFrom(.topSlide)
                .position(.center)
        }
    }
}


#Preview {
    ActiveTricksView(activeTricks: [
        ActiveTrick(trick: SnailTrick(), remainingDuration: 5),
        ActiveTrick(trick: ShuffleTargetTrick(), remainingDuration: 1)
    ], attemptCount: 7)
}

#Preview("Empty") {
    ActiveTricksView(activeTricks: [], attemptCount: 0)
}

#Preview("With Attempts Only") {
    ActiveTricksView(activeTricks: [], attemptCount: 3)
}

#Preview("TrickDetailView") {
    TrickDetailView(activeTrick: ActiveTrick(trick: SnailTrick(), remainingDuration: 3))
}
