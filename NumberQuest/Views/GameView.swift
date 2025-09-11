import SwiftUI
import SwiftData

struct GameView: View {
    @StateObject private var gameManager = GameManager()
    @State private var firstDigit = 0
    @State private var secondDigit = 0
    @State private var thirdDigit = 0

    var body: some View {
        NavigationView() {
            VStack(spacing: 30) {
                // Game Title
                Text("🎯 Guess the Number")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Message Area (top)
                VStack(spacing: 0) {
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

                VStack() {
                    NumberPickerView(
                        firstDigit: $firstDigit,
                        secondDigit: $secondDigit,
                        thirdDigit: $thirdDigit,
                        gameManager: gameManager
                    )
                    .padding(.bottom, 30)
                    
                    // New Game Button (appears when game is won)
                    if gameManager.gameWon {
                        Button(action: {
                            gameManager.startNewGame()
                            // Reset pickers
                            firstDigit = 0
                            secondDigit = 0
                            thirdDigit = 0
                        }) {
                            Text("New Game")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.blue)
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
            }
            .navigationTitle("Number Quest")
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    GameView()
}
