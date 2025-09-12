import SwiftUI
import PopupView

struct ActiveTricksView: View {
    let activeTricks: [ActiveTrick]
    @State var selectedTrick: ActiveTrick?
    @State var showPopup = false
    
    var body: some View {
        if !activeTricks.isEmpty {
            HStack(alignment: .center, spacing: 8) {
                ForEach(activeTricks.indices, id: \.self) { index in
                    let activeTrick = activeTricks[index]
                    Button(action: {
                        selectedTrick = activeTrick
                        showPopup = true
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
}


#Preview {
    ActiveTricksView(activeTricks: [
        ActiveTrick(trick: SnailTrick(), remainingDuration: 5),
        ActiveTrick(trick: ShuffleTargetTrick(), remainingDuration: 1)
    ])
}

#Preview("TrickDetailView") {
    TrickDetailView(activeTrick: ActiveTrick(trick: SnailTrick(), remainingDuration: 3))
}
