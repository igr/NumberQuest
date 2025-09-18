import SwiftUI

protocol Theme {
    var digitPickerSelected: Color { get }
    var numberAction: Color { get }
    var bubbleSystem: Color { get }
    var bubbleSystemWin: Color { get }
    var bubbleTrick: Color { get }
    var trickAction: Color { get }
}

struct DefaultTheme: Theme {
    var digitPickerSelected: Color { Color.blue }
    var numberAction: Color { Color.green }
    var bubbleSystem: Color { Color.blue }
    var bubbleSystemWin: Color { Color.yellow }
    var bubbleTrick: Color { Color.yellow }
    var trickAction: Color { Color.yellow }
}
