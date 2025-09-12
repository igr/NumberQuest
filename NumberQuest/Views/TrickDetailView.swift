import SwiftUI
import PopupView

struct TrickDetailView: View {
    @Environment(\.popupDismiss) var dismiss
    let activeTrick: ActiveTrick
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with icon
            VStack(spacing: 8) {
                Text(activeTrick.trick.icon)
                    .font(.system(size: 60))
                
                Text(activeTrick.trick.name)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 20)
            
            // Description
            VStack(alignment: .leading, spacing: 8) {
                Text(activeTrick.trick.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)

            
            // Progress bar
            if (activeTrick.trick.duration > 0) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Turns left")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(activeTrick.trick.duration - activeTrick.remainingDuration)/\(activeTrick.trick.duration)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(activeTrick.remainingDuration <= 2 ? Color.red : Color.blue)
                                .frame(
                                    width: geometry.size.width * (Double(activeTrick.trick.duration - activeTrick.remainingDuration) / Double(activeTrick.trick.duration)),
                                    height: 12
                                )
                                .animation(.easeInOut(duration: 0.3), value: activeTrick.remainingDuration)
                        }
                    }
                    .frame(height: 8)
                }
                .padding(.horizontal, 20)
            }
                        
            Button {
                dismiss?()
            } label: {
                Text("OK!")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
        .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
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
