import SwiftUI
import AudioToolbox

struct DigitPicker: View {
    @Binding var selectedIndex: Int
    
    init(selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
    }
    
    private let digits = Array(0...9)
    private var digitFont: Font {
        .system(size: 30, weight: .bold, design: .monospaced)
    }
    
    var body: some View {
        Picker(selection: $selectedIndex, label: Text("digit picker")) {
            ForEach(digits, id: \.self) { num in
                Text("\(num)")
                    .font(digitFont)
                    .foregroundColor(num == selectedIndex ? .blue : .gray)
                    .tag(num) // tag must match the type of selectedIndex
            }
        }
        .pickerStyle(.wheel)
        .scaleEffect(3)
        .frame(maxWidth: 40, maxHeight: 80)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var digit = 5

        var body: some View {
            VStack(spacing: 30) {
                Text("Selected Digit: \(digit)")
                    .font(.title)
                
                DigitPicker(selectedIndex: $digit)
                    .frame(width: 100, height: 250)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                HStack {
                    Button("Set to 3") {
                        digit = 3
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Set to 0") {
                        digit = 0
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Set to 7") {
                        digit = 7
                    }
                    .buttonStyle(.bordered)
                    Button("Set to 1") {
                        digit = 1
                    }
                    .buttonStyle(.bordered)
                    Button("Set to 19") {
                        digit = 9
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}
