import SwiftUI

struct PolkaDotBackground: View {
    var dotColor: Color = .blue
    var dotSize: CGFloat = 12
    var spacing: CGFloat = 28    // distance between centers
    var opacity: CGFloat = 1.0
    var offset: CGSize = .zero   // shift pattern

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let cols = Int((size.width + spacing) / spacing) + 1
                let rows = Int((size.height + spacing) / spacing) + 1

                for row in 0..<rows {
                    for col in 0..<cols {
                        // stagger every other row for nicer packing (optional)
                        let stagger = (row % 2 == 0) ? 0.0 : spacing / 2.0
                        let x = CGFloat(col) * spacing + CGFloat(stagger) + offset.width
                        let y = CGFloat(row) * spacing + offset.height
                        let circleRect = CGRect(x: x - dotSize/2, y: y - dotSize/2, width: dotSize, height: dotSize)

                        // Only draw if within visible area (cheap guard)
                        if circleRect.intersects(CGRect(origin: .zero, size: size).insetBy(dx: -spacing, dy: -spacing)) {
                            var path = Path()
                            path.addEllipse(in: circleRect)
                            context.fill(path, with: .color(dotColor.opacity(Double(opacity))))
                        }
                    }
                }
            }
        }
        .compositingGroup() // helps performance for some effects
    }
}
