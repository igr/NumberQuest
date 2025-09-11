import SwiftUI

struct NumberPickerView: View {
    @Binding var firstDigit: Int
    @Binding var secondDigit: Int
    @Binding var thirdDigit: Int
    
    var onGuess: (Int) -> Void
    
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
