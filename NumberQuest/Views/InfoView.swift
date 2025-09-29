import SwiftUI
import UIKit

struct InfoView: View {
    let gameProgress: GameProgressData
    
    var body: some View {

        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .center, spacing: 8) {
                Image(uiImage: Bundle.main.icon ?? UIImage())
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 4)
                
                Text("Number Quest 7")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Guess a Number - With a Twist")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Text("Version \(appVersion) (\(buildNumber))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome to **Number Quest Seven**, where traditional number guessing meets strategic gameplay! Use your wits and outsmart the _Tricks_ and find the _Target_ number.")
                    .font(.body)

                Text("Tricks")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)

                //ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(AllTricks.tricks.dropFirst(), id: \.type) { trick in
                            TrickCard(
                                trick: trick,
                                enabled: gameProgress.getTrickState(trick.type)
                            )
                        }
                    }
                    
                //}
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    let progress = GameProgressData()
    progress.setTrickState(.shuffleTarget, true)
    progress.setTrickState(.snail, true)
    progress.setTrickState(.magnet, true)
    progress.setTrickState(.mirror, true)
    progress.setTrickState(.runner, true)
    progress.setTrickState(.blow, true)

    return NavigationStack {
        InfoView(gameProgress: progress)
    }
}
