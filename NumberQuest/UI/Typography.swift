import SwiftUI

// TODO: Use this
struct Typography {
    let sideboard: Font!

    init() {
        self.sideboard = Font.system(size: 14).weight(.semibold)
    }
}

extension Font {
    static let App = Typography()
}
