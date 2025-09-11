import SwiftUI

struct NumberPickerView: View {
    @Binding var firstDigit: Int
    @Binding var secondDigit: Int
    @Binding var thirdDigit: Int
    @ObservedObject var gameManager: GameManager
    
    @State private var firstDigitOptional: Int? = nil
    @State private var secondDigitOptional: Int? = nil
    @State private var thirdDigitOptional: Int? = nil
    
    private var digitFont: Font {
        .system(size: 60, weight: .bold, design: .monospaced)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                // First Digit Picker
                DigitPicker(selectedIndex: $firstDigitOptional)
                    .frame(width: 100, height: 180)
                
                // Second Digit Picker
                DigitPicker(selectedIndex: $secondDigitOptional)
                    .frame(width: 80, height: 180)
                
                // Third Digit Picker
                DigitPicker(selectedIndex: $thirdDigitOptional)
                    .frame(width: 80, height: 180)
            }
            
            // Guess Button
            Button(action: {
                gameManager.makeGuess(firstDigit: firstDigit, secondDigit: secondDigit, thirdDigit: thirdDigit)
            }) {
                Text("Make Guess")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(gameManager.gameWon ? Color.gray : Color.green)
                    )
            }
            .disabled(gameManager.gameWon)
            
            // New Game Button (appears when game is won)
            if gameManager.gameWon {
                Button(action: {
                    gameManager.startNewGame()
                    // Reset pickers
                    firstDigit = 0
                    secondDigit = 0
                    thirdDigit = 0
                    firstDigitOptional = 0
                    secondDigitOptional = 0
                    thirdDigitOptional = 0
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
        .onAppear {
            // Initialize optional values from bindings
            firstDigitOptional = firstDigit
            secondDigitOptional = secondDigit
            thirdDigitOptional = thirdDigit
        }
        .onChange(of: firstDigitOptional) { _, newValue in
            if let newValue {
                firstDigit = newValue
            }
        }
        .onChange(of: secondDigitOptional) { _, newValue in
            if let newValue {
                secondDigit = newValue
            }
        }
        .onChange(of: thirdDigitOptional) { _, newValue in
            if let newValue {
                thirdDigit = newValue
            }
        }
        .onChange(of: firstDigit) { _, newValue in
            firstDigitOptional = newValue
        }
        .onChange(of: secondDigit) { _, newValue in
            secondDigitOptional = newValue
        }
        .onChange(of: thirdDigit) { _, newValue in
            thirdDigitOptional = newValue
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var firstDigit = 5
        @State private var secondDigit = 2
        @State private var thirdDigit = 7
        @StateObject private var gameManager = GameManager()
        
        var body: some View {
            NumberPickerView(
                firstDigit: $firstDigit,
                secondDigit: $secondDigit,
                thirdDigit: $thirdDigit,
                gameManager: gameManager
            )
        }
    }
    
    return PreviewWrapper()
}
