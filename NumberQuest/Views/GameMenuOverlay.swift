import SwiftUI

struct GameMenuOverlay: View {
    @State private var menuOpen = false
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
                                Text("🚀")
                                    .font(.title)
                                    .accessibilityLabel("Restart Game")
                            }
                            NavigationLink(destination: InfoView()) {
                                Text("🎯")
                                    .font(.title)
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
                GameMenuOverlay(onRestart: {
                    print("Restart game")
                })
            )
    }
}
