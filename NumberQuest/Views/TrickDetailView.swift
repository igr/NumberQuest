import SwiftUI
import PopupView

struct TrickDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.popupDismiss) var dismiss
    let trick: any GameTrick
    
    var body: some View {
        let probability = AllTricks.calcTrickProbability(trick)
        
        VStack(spacing: 20) {
            // Header with icon
            VStack(spacing: 8) {
                Text(trick.icon)
                    .font(.system(size: 60))
                
                Text(trick.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top, 20)
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text(trick.description)
                    .font(.system(size: 18))
                    .italic(true)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Chance: \(probability, specifier: "%.2f") %")
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
        .background(Color.theme.background(colorScheme).cornerRadius(20))
        .shadowedStyle()
        .padding(.horizontal, 40)
    }
}

#Preview {
    TrickDetailView(trick: AllTricks.tricks[2])
}

#Preview("Dark Mode") {
    TrickDetailView(trick: AllTricks.tricks[2])
        .preferredColorScheme(.dark)
}

#Preview("Shuffle Trick") {
    TrickDetailView(trick: AllTricks.tricks[3])
}
