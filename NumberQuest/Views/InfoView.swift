import SwiftUI
import UIKit


struct InfoView: View {    
    var body: some View {
        ScrollView {
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
                    Text("Welcome to Number Quest 7, where traditional number guessing meets strategic gameplay!")
                    Text("Use your wits and special tricks to outsmart the system and find the secret number.")
                }
                .font(.body)
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tricks")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        TrickCard(icon: "🎯", title: "Precision", description: "Narrow down possibilities")
                        TrickCard(icon: "🔍", title: "Analyze", description: "Study patterns")
                        TrickCard(icon: "⚡", title: "Quick Strike", description: "Fast elimination")
                        TrickCard(icon: "🎲", title: "Random", description: "Surprise moves")
                        TrickCard(icon: "🧠", title: "Logic", description: "Systematic approach")
                        TrickCard(icon: "💡", title: "Insight", description: "Smart deduction")
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

struct TrickCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title)
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(12)
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
