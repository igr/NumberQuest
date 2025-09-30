import SwiftUI

struct GameMenuOverlay: View {
    @State private var menuOpen = false
    let gameProgress: GameProgressData
    let onRestart: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack(alignment: .topTrailing) {
                    if menuOpen {
                        VStack(alignment: .center, spacing: 16) {
                            Button(action: { withAnimation { menuOpen = false } }) {
                                Image(systemName: "xmark.circle")
                                    .imageScale(.large)
                                    .accessibilityLabel("Close menu")
                            }
                            Button(action: {
                                onRestart()
                                withAnimation { menuOpen = false }
                            }) {
                                VStack(spacing: 4) {
                                    Text("🚀")
                                        .font(.title)
                                    Text("Restart")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .accessibilityLabel("Restart Game")
                            }
                            NavigationLink(destination: InfoView(gameProgress: gameProgress)) {
                                VStack(spacing: 4) {
                                    Text("🎯")
                                        .font(.title)
                                    Text("Info")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .accessibilityLabel("Info")
                            }
                        }
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 5)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    } else {
                        Button(action: { withAnimation { menuOpen.toggle() } }) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .padding(12)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 1)
                                .accessibilityLabel("Open menu")
                        }
                    }
                }
            }
            .padding(.top, 20)
            .padding(.trailing, 20)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        Color.gray.opacity(0.3)
            .overlay(
                GameMenuOverlay(
                    gameProgress: GameProgressData(),
                    onRestart: {print("Restart game")})
            )
    }
}
