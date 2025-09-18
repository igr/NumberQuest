import SwiftUI

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var current: Theme
    init() {
        self.current = DefaultTheme()
    }
}

extension Color {
    static var theme: Theme {
        ThemeManager.shared.current
    }
}
