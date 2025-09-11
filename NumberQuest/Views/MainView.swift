import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Number Quest")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: GameView()) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start New Game")
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                }
                
                Button("Settings") {
                    // Navigate to settings
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainView()
}
