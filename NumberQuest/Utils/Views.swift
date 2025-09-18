import SwiftUI
import PopupView

extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 255)
        case 8: // RGBA (32-bit)
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 0xff,
            green: Double(g) / 0xff,
            blue: Double(b) / 0xff,
            opacity: Double(a) / 0xff
        )
    }
}

extension View {
    
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }

#if os(iOS)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
#endif
}

#if os(iOS)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif

extension View {
    /// Presents a popup for an Identifiable `item` with the app's "trick" styling.
    /// Usage:
    ///   .trickPopup(item: $selectedTrick) { trick in
    ///       TrickDetailView(activeTrick: trick)
    ///   }
    func trickPopup<Item: Identifiable & Equatable, Content: View>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.popup(item: item) { item in
            content(item)
        } customize: {
            $0
            .type(.floater())
            .closeOnTap(true)
            .appearFrom(.topSlide)
            .backgroundColor(Color(white: 1.0, opacity: 0.5))
            .position(.center)
        }
    }
    
    func winPopup<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.popup(isPresented: isPresented) {
            content()
        } customize: {
           $0
           .type(.floater())
           .closeOnTap(false)
           .backgroundColor(Color(white: 1.0, opacity: 0.5))
           .position(.center)
           .appearFrom(.centerScale)
       }
    }

}
