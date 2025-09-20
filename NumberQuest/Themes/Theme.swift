import SwiftUI

protocol Theme {
    var digitPickerSelected: Color { get }
    var numberAction: Color { get }
    var bubbleSystem: Color { get }
    var bubbleSystemWin: Color { get }
    var bubbleTrick: Color { get }
    var trickAction: Color { get }
    var attempt: Color { get }
    func background(_ scheme: ColorScheme) -> Color
}

// https://flatuicolors.com/palette/nl
struct DefaultTheme: Theme {
    var digitPickerSelected: Color { Color(hex: "#006266") }
    var numberAction: Color { Color(hex: "#009432") }
    var bubbleSystem: Color { Color(hex: "#0652DD") }
    var bubbleSystemWin: Color { Color(hex: "#FFC312") }
    var bubbleTrick: Color { Color(hex: "#FFC312") }
    var trickAction: Color { Color(hex: "#FFC312") }
    var attempt: Color { Color(hex: "#EA2027") }
    func background(_ scheme: ColorScheme) -> Color {
        switch scheme {
        case .dark:
            return Color(hex: "#1F2022")
        default:
            return Color(hex: "#F0F0F0")
        }
    }
}
