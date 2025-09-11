import SwiftUI
import SwiftData

struct GameView: View {
    @StateObject private var gameManager = GameManager()
    @State private var firstDigit = 0
    @State private var secondDigit = 0
    @State private var thirdDigit = 0

    var body: some View {
        NavigationView() {
            VStack(spacing: 20) {
                // Game Title
                Text("🎯 Number Quest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Chat Window
                ChatWindow(messages: $gameManager.chatMessages)
                    .frame(maxHeight: 300)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                // Attempts counter
                if gameManager.attempts > 0 {
                    Text("Attempts: \(gameManager.attempts)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                VStack() {
                    NumberPickerView(
                        firstDigit: $firstDigit,
                        secondDigit: $secondDigit,
                        thirdDigit: $thirdDigit,
                    ) { value in
                        gameManager.makeGuess(value)
                    }
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
                            Text("🎮 New Game")
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
            .onAppear {
                if !gameManager.gameStarted {
                    gameManager.startNewGame()
                }
            }
        }
    }
}

#Preview {
    GameView()
}
