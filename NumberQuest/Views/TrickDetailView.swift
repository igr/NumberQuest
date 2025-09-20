import SwiftUI
import PopupView

struct TrickDetailView: View {
    @Environment(\.popupDismiss) var dismiss
    let activeTrick: ActiveTrick
    
    var body: some View {
        let probability = AllTricks.calcTrickProbability(activeTrick)
        let thisProb = probability.0
        let totalProb = probability.1
        
        VStack(spacing: 20) {
            // Header with icon
            VStack(spacing: 8) {
                Text(activeTrick.trick.icon)
                    .font(.system(size: 60))
                
                Text(activeTrick.trick.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top, 20)
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text(activeTrick.trick.description)
                    .font(.system(size: 18))
                    .italic(true)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Chance: \(Int(thisProb)) / \(Int(totalProb))")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.secondary)
                        
            Button {
                dismiss?()
            } label: {
                Text("OK")
                    .font(.system(size: 22, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .foregroundColor(.black)
                    .background(Color.theme.trickAction)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(EdgeInsets(top: 32, leading: 24, bottom: 32, trailing: 24))
        .background(Color.white.cornerRadius(20))
        .shadowedStyle()
        .padding(.horizontal, 40)
    }
}

#Preview {
    TrickDetailView(activeTrick: ActiveTrick(trick: SnailTrick(), remainingDuration: 3))
}

#Preview("Almost Expired") {
    TrickDetailView(activeTrick: ActiveTrick(trick: SnailTrick(), remainingDuration: 1))
}

#Preview("Shuffle Trick") {
    TrickDetailView(activeTrick: ActiveTrick(trick: ShuffleTargetTrick(), remainingDuration: 0))
}
