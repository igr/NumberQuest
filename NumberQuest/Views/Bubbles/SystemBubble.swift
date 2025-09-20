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
            return "🎯 Guess a number!"
        case .victory:
            return "🎉 Congratulations! You won!"
        case .debug(let activeTricks, let target):
            if activeTricks.isEmpty {
                return "✨ No active tricks."
            } else {
                let trickList = activeTricks.map { "• \($0.trick.name) (\($0.remainingDuration) turns left)" }.joined(separator: "\n")
                return "🎯 \(target)\n⚡ Active Tricks:\n\(trickList)"
            }
        }
    }
    
    var systemColor: Color {
        switch systemMessage.messageType {
        case .tooHigh, .tooLow, .welcome:
            return Color.theme.bubbleSystem
        case .victory:
            return Color.theme.bubbleSystemWin
        case .debug:
            return .gray
        }
    }
    var systemForgroundColor: Color {
        switch systemMessage.messageType {
        case .tooHigh, .tooLow, .welcome:
            return .white
        case .victory:
            return Color.black
        case .debug:
            return .gray
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(systemText)
                    .foregroundColor(systemForgroundColor)
                    .font(.title2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(systemColor)
                    .shadow(color: systemColor.opacity(0.3), radius: 4, x: 2, y: 2)
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview("welcome") {
    SystemBubble(systemMessage: SystemMessage(type: .welcome))
}
#Preview("toolow") {
    SystemBubble(systemMessage: SystemMessage(type: .tooLow(currentGuess: 123)))
}
#Preview("toohigh") {
    SystemBubble(systemMessage: SystemMessage(type: .tooHigh(currentGuess: 123)))
}
#Preview("victory") {
    SystemBubble(systemMessage: SystemMessage(type: .victory(targetNumber: 123, attempts:3)))
}
