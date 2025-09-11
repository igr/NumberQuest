import SwiftUI
import SwiftData

struct GameView: View {
    @StateObject private var gameManager = GameManager()
    @State private var firstDigit = 0
    @State private var secondDigit = 0
    @State private var thirdDigit = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Game Title
                Text("🎯 Guess the Number")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Message Area (top)
                VStack {
                    Text(gameManager.message)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(gameManager.gameWon ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                        )
                    
                    if gameManager.attempts > 0 {
                        Text("Attempts: \(gameManager.attempts)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Current Guess Display
                HStack(spacing: 10) {
                    Text("Your Guess:")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                NumberPickerView(
                    firstDigit: $firstDigit,
                    secondDigit: $secondDigit,
                    thirdDigit: $thirdDigit,
                    gameManager: gameManager
                )
                .padding(.bottom, 30)
            }
            .navigationTitle("Guess Game")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    GameView()
}
