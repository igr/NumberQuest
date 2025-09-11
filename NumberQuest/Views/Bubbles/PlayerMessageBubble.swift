import SwiftUI
import Foundation

struct PlayerMessageBubble: View {
    let playerMessage: PlayerMessage
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            VStack(alignment: .center, spacing: 4) {
                Text("\(playerMessage.guess)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("#\(playerMessage.attempt)")
                    .foregroundColor(.black.opacity(0.8))
                    .font(.title3)
                    .fontWeight(.medium)

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green)
                    .shadow(color: Color.green.opacity(0.3), radius: 4, x: 0, y: 2)
            )
            .frame(maxWidth: 200, alignment: .trailing)
        }
        .padding(.horizontal, 16)
    }
}
