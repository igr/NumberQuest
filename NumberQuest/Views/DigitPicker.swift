import SwiftUI
import AudioToolbox

struct DigitPicker: View {
    @Binding var selectedIndex: Int?
    
    init(selectedIndex: Binding<Int?>) {
        self._selectedIndex = selectedIndex
    }
        
    private var soundId: SystemSoundID = 1157
    
    private let digits = Array(0...9)
    private let itemHeight: CGFloat = 60
    private let visibleItems = 3
    
    private func selectedNdx() -> Int {
        return selectedIndex ?? 0
    }
    
    private var digitFont: Font {
        .system(size: 60, weight: .bold, design: .monospaced)
    }
    
    var padding: CGFloat {
        let selectedIndex = selectedNdx()
        if selectedIndex == 0 || selectedIndex == digits.last {
            return itemHeight * (CGFloat(visibleItems) / 2 - 0.5)
        } else {
            return 0
        }
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(digits, id: \.self) { digitValue in
                    Text("\(digitValue)")
                        .font(digitFont)
                        .foregroundColor(colorForDigit(at: digitValue))
                        .frame(height: itemHeight)
                        .scaleEffect(scaleForDigit(at: digitValue))
                        .opacity(opacityForDigit(at: digitValue))
                        .id(digitValue)
                }
            }
            .padding(.vertical, padding)
            .scrollTargetLayout()
        }
        .scrollPosition(id: $selectedIndex, anchor: .center)
        .frame(height: itemHeight * CGFloat(visibleItems))
        .scrollTargetBehavior(.viewAligned)
        .scrollDisabled(false)
        .onChange(of: selectedIndex) { _, newValue in
            if let newValue {
                let clamped = min(max(newValue, digits.first!), digits.last!)
                if clamped != selectedIndex {
                    selectedIndex = clamped

                }
            }
        }
        .onChange(of: selectedIndex, initial: false) {
            AudioServicesPlaySystemSound(soundId)
            withAnimation {
                selectedIndex = selectedIndex
            }
        }
        .overlay(
            GeometryReader { geo in
                let centerY = geo.size.height / 2
                let halfItem = itemHeight / 2
                
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .position(x: geo.size.width / 2, y: centerY - halfItem)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                        .position(x: geo.size.width / 2, y: centerY + halfItem)
                }
            }
            .allowsHitTesting(false)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func colorForDigit(at index: Int) -> Color {
        let distance = abs(index - selectedNdx())
        if distance == 0 {
            return .blue
        } else if distance <= 1 {
            return .primary
        } else if distance <= 2 {
            return .secondary
        } else {
            return .secondary.opacity(0.5)
        }
    }
    
    private func scaleForDigit(at index: Int) -> CGFloat {
        let distance = abs(index - selectedNdx())
        if distance == 0 {
            return 1.0
        } else if distance <= 1 {
            return 0.6
        } else {
            return 0.4
        }
    }
    
    private func opacityForDigit(at index: Int) -> Double {
        let distance = abs(index - selectedNdx())
        if distance == 0 {
            return 1.0
        } else if distance <= 1 {
            return 0.7
        } else if distance <= 2 {
            return 0.4
        } else {
            return 0.2
        }
    }
        
}

#Preview {
    struct PreviewWrapper: View {
        @State private var digit: Int? = 5

        var body: some View {
            VStack(spacing: 30) {
                Text("Selected Digit: \(digit ?? -1)")
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
