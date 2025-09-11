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
                HStack(spacing: 20) {
                    Text("Your Guess:")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 5) {
                        Text("\(firstDigit)")
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                        Text("\(secondDigit)")
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                        Text("\(thirdDigit)")
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.blue)
                    }
                }
                
                // Digit Pickers (bottom area)
                VStack(spacing: 20) {
                    Text("Pick your 3 digits:")
                        .font(.headline)
                    
                    HStack(spacing: 30) {
                        // First Digit Picker
                        VStack {
                            Text("Hundreds")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("First Digit", selection: $firstDigit) {
                                ForEach(0...9, id: \.self) { digit in
                                    Text("\(digit)")
                                        .font(.title)
                                        .tag(digit)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80, height: 120)
                            .clipped()
                        }
                        
                        // Second Digit Picker
                        VStack {
                            Text("Tens")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Second Digit", selection: $secondDigit) {
                                ForEach(0...9, id: \.self) { digit in
                                    Text("\(digit)")
                                        .font(.title)
                                        .tag(digit)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80, height: 120)
                            .clipped()
                        }
                        
                        // Third Digit Picker
                        VStack {
                            Text("Units")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Picker("Third Digit", selection: $thirdDigit) {
                                ForEach(0...9, id: \.self) { digit in
                                    Text("\(digit)")
                                        .font(.title)
                                        .tag(digit)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 80, height: 120)
                            .clipped()
                        }
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
