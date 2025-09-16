import SwiftUI

struct ConfettiView: UIViewRepresentable {
    func makeUIView(context: Context) -> SwiftConfettiView {
        let confettiView = SwiftConfettiView()
        confettiView.startConfetti()
        return confettiView
    }
    
    func updateUIView(_ uiView: SwiftConfettiView, context: Context) {}
}

struct WinView: View {
    let targetNumber: Int
    let attempts: Int
    let onStartAgain: () -> Void
        
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Text("🎉")
                    .font(.system(size: 80))
                    .scaleEffect(1.2)
                
                Text("You Win!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Success message
                VStack(spacing: 8) {
                    Text("You guessed the number")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("\(targetNumber)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text("in")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("\(attempts)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                    
                    Text("attempt\(attempts == 1 ? "" : "s")!")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                // Start Again button
                Button(action: onStartAgain) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("New Game")
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.green)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 40)
            ConfettiView().ignoresSafeArea()
        }
    }
}

#Preview {
    WinView(targetNumber: 742, attempts: 5) {
        print("Start new game")
    }
}
