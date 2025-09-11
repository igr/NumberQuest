import SwiftUI

struct NumberPickerView: View {
    @Binding var firstDigit: Int
    @Binding var secondDigit: Int
    @Binding var thirdDigit: Int
    
    var onGuess: (Int) -> Void
    
    @State private var firstDigitOptional: Int? = nil
    @State private var secondDigitOptional: Int? = nil
    @State private var thirdDigitOptional: Int? = nil
    
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
                let number = (firstDigitOptional ?? 0) * 100
                    + (secondDigitOptional ?? 0) * 10
                    + (thirdDigitOptional ?? 0)
                onGuess(number)
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Make Guess")
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green)
                )
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
        
        var body: some View {
            NumberPickerView(
                firstDigit: $firstDigit,
                secondDigit: $secondDigit,
                thirdDigit: $thirdDigit,
                onGuess: { number in
                    print("Guess made with number: \(number)")
                }
            )
        }
    }
    
    return PreviewWrapper()
}
