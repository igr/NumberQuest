import SwiftUI
import Foundation

struct TrickMessageBubble: View {
    let trickMessage: TrickMessage
    
    private var trickColor: Color {
        return .yellow
    }
    private var trickText: String {
        return trickMessage.trick.message
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 2) {
                Text(trickText)
                    .foregroundColor(.primary)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .italic()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(trickColor.opacity(0.2))
                    .stroke(trickColor.opacity(0.5), lineWidth: 1)
            )
            .frame(maxWidth: 250)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    
}
