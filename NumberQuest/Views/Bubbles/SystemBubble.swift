import SwiftUI
import Foundation

struct SystemBubble: View {
    let systemMessage: SystemMessage
    
    private var systemText: String {
        switch systemMessage.messageType {
        case .tooHigh(_, let content):
            return content
        case .tooLow(_, let content):
            return content
        case .welcome:
            return "🎯 Welcome! Guess a Number!"
        case .victory:
            return "🎉 Congratulations! You won!"
        case .debug(let activeTricks, let target):
            if activeTricks.isEmpty {
                return "✨ No active tricks"
            } else {
                let trickList = activeTricks.map { "• \($0.trick.name) (\($0.remainingDuration) turns left)" }.joined(separator: "\n")
                return "🎯 \(target)\n⚡ Active Tricks:\n\(trickList)"
            }
        }
    }
    
    var systemColor: Color {
        switch systemMessage.messageType {
        case .tooHigh, .tooLow:
            return .blue
        case .welcome:
            return .green
        case .victory:
            return .yellow
        case .debug:
            return .gray
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
                    .fill(systemColor)
            )
            .frame(maxWidth: 280, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
