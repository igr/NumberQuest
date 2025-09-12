import SwiftUI
import SwiftData

struct GameView: View {
    @StateObject private var state = GameState()
    @StateObject private var gameManager: GameManager
    
    @State private var firstDigit = 0
    @State private var secondDigit = 0
    @State private var thirdDigit = 0
    
    init() {
        let gameState = GameState()
        _state = StateObject(wrappedValue: gameState)
        _gameManager = StateObject(wrappedValue: GameManager(state: gameState))
    }
    
    private var isGuessEnabled: Binding<Bool> {
        Binding(
            get: { !state.thinking && !state.gameWon },
            set: { _ in /* Read-only computed binding */ }
        )
    }

    var body: some View {
        NavigationView() {
            VStack(spacing: 20) {
                Text("🎯 Number Quest")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ActiveTricksView(activeTricks: state.activeTricks)
                
                ChatWindow(messages: $state.chatMessages)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                // Attempts counter
                if state.attempts > 0 {
                    Text("Attempts: \(state.attempts)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                VStack() {
                    NumberPickerView(
                        firstDigit: $firstDigit,
                        secondDigit: $secondDigit,
                        thirdDigit: $thirdDigit,
                        isEnabled: isGuessEnabled
                    ) { value in
                        gameManager.makeGuess(value)
                    }
                    .padding(.bottom, 30)                    
                    
                    // New Game Button (appears when game is won)
                    if state.gameWon {
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
            .edgesIgnoringSafeArea(.bottom)
            .onAppear {
                if !state.gameStarted {
                    gameManager.startNewGame()
                }
            }
        }
    }
}

#Preview {
    GameView()
}
