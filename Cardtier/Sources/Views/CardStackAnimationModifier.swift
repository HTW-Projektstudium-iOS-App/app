import SwiftUI

struct CardStackAnimationModifier: ViewModifier {
    let index: Int
    let stackDepth: Int
    let scrollProgress: CGFloat
    let isFocused: Bool
    let isScrolling: Bool
    let scrollVelocity: CGFloat

    func body(content: Content) -> some View {
        // Calculate animation parameters using extracted constants
        let yOffset = CardStackAnimationConstants.yOffsetMultiplier * CGFloat(index) * scrollProgress
        let scale = 1.0 - (CardStackAnimationConstants.scaleDepthMultiplier * CGFloat(index) * scrollProgress)
        let blur = CardStackAnimationConstants.blurDepthMultiplier * CGFloat(index) * scrollProgress
        let opacity = 1.0 - (CardStackAnimationConstants.opacityDepthMultiplier * CGFloat(index) * scrollProgress)
        let tilt = isScrolling ? CardStackAnimationConstants.tiltMultiplier * Double(scrollVelocity) * Double(index) * Double(scrollProgress) : 0
        let shadow = CardStackAnimationConstants.shadowBase + CardStackAnimationConstants.shadowDepthMultiplier * CGFloat(index) * scrollProgress

        return content
            // Focused card gets special scale, opacity, blur, and offset
            .scaleEffect(isFocused ? CardDesign.Layout.focusedScale : scale)
            .opacity(isFocused ? 1.0 : opacity)
            .blur(radius: isFocused ? 0 : blur)
            .offset(y: isFocused ? 0 : yOffset)
            // 3D tilt effect when scrolling
            .rotation3DEffect(
                .degrees(isFocused ? 0 : tilt),
                axis: (x: 1, y: 0, z: 0),
                anchor: .center,
                perspective: CardStackAnimationConstants.perspective
            )
            // Dynamic shadow based on focus and stack depth
            .shadow(
                color: .black.opacity(
                    isFocused
                        ? CardStackAnimationConstants.focusedShadowOpacity
                        : CardStackAnimationConstants.unfocusedShadowOpacityBase + CardStackAnimationConstants.unfocusedShadowOpacityDepth * CGFloat(index) * scrollProgress
                ),
                radius: shadow,
                x: 0,
                y: isFocused ? CardStackAnimationConstants.focusedShadowYOffset : shadow
            )
            // Spring animation for smooth transitions
            .animation(
                .spring(
                    response: CardStackAnimationConstants.animationResponse,
                    dampingFraction: CardStackAnimationConstants.animationDamping
                ),
                value: scrollProgress
            )
    }
}
