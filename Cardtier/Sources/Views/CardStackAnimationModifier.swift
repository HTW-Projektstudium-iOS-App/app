import SwiftUI

struct CardStackAnimationModifier: ViewModifier {
    let index: Int
    let stackDepth: Int
    let scrollProgress: CGFloat
    let isFocused: Bool
    let isScrolling: Bool
    let scrollVelocity: CGFloat

    func body(content: Content) -> some View {
        // Overlap: offset cards upward based on stack depth
        let yOffset = CGFloat(-28 * CGFloat(index) * scrollProgress)
        // Scale down cards deeper in stack
        let scale = 1.0 - (0.06 * CGFloat(index) * scrollProgress)
        // Blur/opacity for depth
        let blur = CGFloat(3.5 * CGFloat(index) * scrollProgress)
        let opacity = 1.0 - (0.13 * CGFloat(index) * scrollProgress)
        // 3D tilt during scroll
        let tilt = isScrolling ? Double(scrollVelocity) * 2.7 * Double(index) * Double(scrollProgress) : 0
        // Shadow depth
        let shadow = CGFloat(8 + 3 * CGFloat(index) * scrollProgress)

        return content
            .scaleEffect(isFocused ? CardDesign.Layout.focusedScale : scale)
            .opacity(isFocused ? 1.0 : opacity)
            .blur(radius: isFocused ? 0 : blur)
            .offset(y: isFocused ? 0 : yOffset)
            .rotation3DEffect(
                .degrees(isFocused ? 0 : tilt),
                axis: (x: 1, y: 0, z: 0),
                anchor: .center,
                perspective: 0.5
            )
            .shadow(
                color: .black.opacity(isFocused ? 0.28 : 0.13 + 0.08 * CGFloat(index) * scrollProgress),
                radius: shadow,
                x: 0, y: isFocused ? 10 : shadow
            )
            .animation(.spring(response: 0.38, dampingFraction: 0.84), value: scrollProgress)
    }
}
