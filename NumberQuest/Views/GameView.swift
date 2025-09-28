import SwiftUI

struct GameView: View {
    @Environment(\.colorScheme) var colorScheme
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
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    ChatWindow(messages: $state.chatMessages)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    
                    ActiveTricksView(activeTricks: state.activeTricks, attemptCount: state.attempts)
                    
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
                    .background(Color.theme.numberAction.opacity(0.1))
                }
                .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? UIScreen.main.bounds.width * 0.2 : 0)
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    if !state.gameStarted {
                        gameManager.startNewGame()
                    }
                }
            }
            .overlay(
                GameMenuOverlay(),
                alignment: .topTrailing
            )
            .winPopup(isPresented: $state.gameWon, colorScheme: colorScheme) {
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
            }
        }
    }
}

#Preview() {
    GameView()
}
#Preview("Dark") {
    GameView()
    .preferredColorScheme(.dark)
}

#Preview("Game Won") {
    let gameState = GameState()
    return GameView(state: gameState)
        .onAppear {
            DispatchQueue.main.async {
                gameState.gameWon = true
            }
        }
}
