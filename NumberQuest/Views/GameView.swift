import SwiftUI
import SwiftData

struct GameView: View {
    @StateObject private var state: GameState
    @StateObject private var gameManager: GameManager

    @State private var firstDigit = 0
    @State private var secondDigit = 0
    @State private var thirdDigit = 0

    init(state: GameState? = nil, gameManager: GameManager? = nil) {
        let gameState = state ?? GameState()
        _state = StateObject(wrappedValue: gameState)
        _gameManager = StateObject(wrappedValue: gameManager ?? GameManager(state: gameState))
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
                
                ActiveTricksView(activeTricks: state.activeTricks, attemptCount: state.attempts)
                
                ChatWindow(messages: $state.chatMessages)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(15)
                    .padding(.horizontal)

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
            .popup(isPresented: $state.gameWon) {
                WinView(
                    targetNumber: state.targetNumber,
                    attempts: state.attempts
                ) {
                    gameManager.startNewGame()
                    // Reset pickers
                    firstDigit = 0
                    secondDigit = 0
                    thirdDigit = 0
                }
            } customize: {
                $0
                .type(.floater())
                .closeOnTap(false)
                .position(.center)
                .appearFrom(.centerScale)
            }
        }
    }
}

#Preview() {
    GameView()
}

#Preview("Game Won") {
    let gameState = GameState()
    return GameViewPreviewWrapper(state: gameState)
        .onAppear {
            DispatchQueue.main.async {
                gameState.gameWon = true
            }
        }
}

// Helper wrapper to inject GameState into GameView for preview
private struct GameViewPreviewWrapper: View {
    @StateObject var state: GameState

    var body: some View {
        GameView(state: state, gameManager: nil)
    }
}
