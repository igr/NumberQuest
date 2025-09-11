import SwiftUI

struct NumberPickerView: View {
    @Binding var firstDigit: Int
    @Binding var secondDigit: Int
    @Binding var thirdDigit: Int
    @ObservedObject var gameManager: GameManager
    
    private var digitFont: Font {
        .system(size: 60, weight: .bold, design: .monospaced)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 30) {
                // First Digit Picker
                Picker("First Digit", selection: $firstDigit) {
                    ForEach(0...9, id: \.self) { digit in
                        Text("\(digit)")
                            .font(digitFont)
                            .foregroundColor(.blue)
                            .tag(digit)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100, height: 120)
                .clipped()
                
                // Second Digit Picker
                Picker("Second Digit", selection: $secondDigit) {
                    ForEach(0...9, id: \.self) { digit in
                        Text("\(digit)")
                            .font(digitFont)
                            .foregroundColor(.blue)
                            .tag(digit)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 120)
                .clipped()
                
                // Third Digit Picker
                Picker("Third Digit", selection: $thirdDigit) {
                    ForEach(0...9, id: \.self) { digit in
                        Text("\(digit)")
                            .font(digitFont)
                            .foregroundColor(.blue)
                            .tag(digit)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 120)
                .clipped()
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
