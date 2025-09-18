import SwiftUI

struct NumberPickerView: View {
    @Binding var firstDigit: Int
    @Binding var secondDigit: Int
    @Binding var thirdDigit: Int
    @Binding var isEnabled: Bool
    
    var onGuess: (Int) -> Void
    
    private let guessingMessages = [
        "Approximate",
        "Bet",
        "Bluff",
        "Cast lots",
        "Chance it",
        "Conjecture",
        "Crack it",
        "Daydream",
        "Deduce",
        "Estimate",
        "Figure it",
        "Forecast",
        "Gamble",
        "Go fish",
        "Guesstimate",
        "Hazard it",
        "Hypothesize",
        "Intuit",
        "Invent",
        "Jot it",
        "Jump in",
        "Posit",
        "Predict",
        "Project",
        "Propose",
        "Reckon",
        "Roll the dice",
        "Shoot",
        "Shoehorn it",
        "Speculate",
        "Spin it",
        "Stab at it",
        "Suppose",
        "Surmise",
        "Swing",
        "Take a crack",
        "Take a stab",
        "Theorize",
        "Try it",
        "Venture",
        "Wager",
        "Wing it"
    ]
    
    private let challengingMessages = [
        "Accomplishing",
        "Actioning",
        "Actualizing",
        "Baking",
        "Brewing",
        "Calculating",
        "Cerebrating",
        "Churning",
        "Clauding",
        "Coalescing",
        "Cogitating",
        "Computing",
        "Conjuring",
        "Considering",
        "Cooking",
        "Crafting",
        "Creating",
        "Crunching",
        "Deliberating",
        "Determining",
        "Doing",
        "Effecting",
        "Finagling",
        "Forging",
        "Forming",
        "Generating",
        "Hatching",
        "Herding",
        "Honking",
        "Hustling",
        "Ideating",
        "Inferring",
        "Manifesting",
        "Marinating",
        "Moseying",
        "Mulling",
        "Mustering",
        "Musing",
        "Noodling",
        "Percolating",
        "Pondering",
        "Processing",
        "Puttering",
        "Reticulating",
        "Ruminating",
        "Schlepping",
        "Shucking",
        "Simmering",
        "Smooshing",
        "Spinning",
        "Stewing",
        "Synthesizing",
        "Thinking",
        "Transmuting",
        "Vibing",
        "Working"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 0) {
                DigitPicker(selectedIndex: $firstDigit)
                    .frame(width: 80, height: 180)
                
                DigitPicker(selectedIndex: $secondDigit)
                    .frame(width: 80, height: 180)
                
                DigitPicker(selectedIndex: $thirdDigit)
                    .frame(width: 80, height: 180)
            }
            
            // Guess Button
            Button(action: {
                let number = firstDigit * 100 + secondDigit * 10 + thirdDigit
                onGuess(number)
            }) {
                HStack {
                    Image(systemName: isEnabled ? "play.fill" : "hourglass")
                    Text(isEnabled ?
                         (guessingMessages.randomElement() ?? "Guess") :
                            (challengingMessages.randomElement() ?? "Challenging") + "...")
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isEnabled
                              ? Color.theme.numberAction
                              : Color.gray)
                )
            }
            .disabled(!isEnabled)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var firstDigit = 5
        @State private var secondDigit = 2
        @State private var thirdDigit = 7
        @State private var isEnabled = true
        
        var body: some View {
            NumberPickerView(
                firstDigit: $firstDigit,
                secondDigit: $secondDigit,
                thirdDigit: $thirdDigit,
                isEnabled: $isEnabled,
                onGuess: { number in
                    print("Guess made with number: \(number)")
                }
            )
        }
    }
    
    return PreviewWrapper()
}

#Preview("Disabled") {
    struct PreviewWrapper: View {
        @State private var firstDigit = 1
        @State private var secondDigit = 7
        @State private var thirdDigit = 3
        @State private var isEnabled = false
        
        var body: some View {
            NumberPickerView(
                firstDigit: $firstDigit,
                secondDigit: $secondDigit,
                thirdDigit: $thirdDigit,
                isEnabled: $isEnabled,
                onGuess: { number in
                    print("Guess made with number: \(number)")
                }
            )
        }
    }
    
    return PreviewWrapper()
}
