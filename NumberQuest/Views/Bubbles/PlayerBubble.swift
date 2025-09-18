import SwiftUI
import Foundation

struct PlayerBubble: View {
    let playerMessage: PlayerMessage
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(alignment: .center, spacing: 4) {
                Text(String(format: "%03d", playerMessage.guess))
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.numberAction)
                    .shadow(color: Color.theme.numberAction.opacity(0.3), radius: 4, x: 2, y: 2)
            )
            .frame(maxWidth: 200, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}


#Preview {
    PlayerBubble(playerMessage: PlayerMessage(guess: 173, attempt: 2))
}
