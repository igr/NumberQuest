import SwiftUI
import UIKit


struct InfoView: View {    
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome to **Number Quest Seven**, where traditional number guessing meets strategic gameplay! Use your wits and special tricks to outsmart the system and find the secret number.")
            }
            .font(.body)
            .padding(.horizontal)
            
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Tricks")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                //ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(AllTricks.tricks.dropFirst(), id: \.type) { trick in
                            TrickCard(
                                icon: trick.icon,
                                title: trick.name
                            )
                        }
                    }
                //}
            }
        }
        .padding()
    }
}

struct TrickCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(icon)
                .font(.title)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 50)
        .padding(6)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}

#Preview {
    NavigationStack {
        InfoView()
    }
}
