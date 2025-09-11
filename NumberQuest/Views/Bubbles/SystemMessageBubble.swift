import SwiftUI
import Foundation

struct SystemMessageBubble: View {
    let systemMessage: SystemMessage
    
    private var systemText: String {
        switch systemMessage.messageType {
        case .tooHigh:
            return "Oops! Your guess is too high."
        case .tooLow:
            return "Oops! Your guess is too low."
        case .welcome:
            return "🎯 Welcome! Guess a Number!"
        case .victory:
            return "Congratulations! You won!"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(systemText)
                    .foregroundColor(.white)
                    .font(.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.blue)
            )
            .frame(maxWidth: 280, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
