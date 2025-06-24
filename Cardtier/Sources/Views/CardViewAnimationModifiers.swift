import SwiftUI 

struct ScrollingAnimation: ViewModifier {
    let isScrolling: Bool
    let scrollVelocity: CGFloat
    let isFocused: Bool
    @State private var animate = false
    @State private var randomFactor = Double.random(in: -0.5...0.5) // Reduced randomness range
    @State private var secondaryRandomFactor = Double.random(in: -0.3...0.3) // More constrained
    @State private var windingDown = false
    @State private var animationIntensity: Double = 1.0
    
    @State private var rotationIntensity: Double = 1.0
    @State private var offsetIntensity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            // More subtle opacity changes - barely noticeable
            .opacity((!isFocused && (isScrolling || windingDown)) ? 0.98 + (0.02 * animationIntensity) : 1.0)
            // Subtle scale effect like paper flexing
            .scaleEffect((!isFocused && (isScrolling || windingDown)) ? 0.997 + (0.003 * (1.0 - animationIntensity)) : 1.0)
            // Primary rotation - cards rotate more on horizontal axis when flipping through a stack
            .rotationEffect(.degrees((!isFocused && (isScrolling || windingDown)) ?
                ((animate ? scrollVelocity * 0.4 : -scrollVelocity * 0.3) * randomFactor * rotationIntensity) : 0))
            // Main 3D effect - primarily around y-axis like flipping pages
            .rotation3DEffect(
                .degrees((!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? scrollVelocity * 0.3 : -scrollVelocity * 0.2) * randomFactor * rotationIntensity) : 0),
                axis: (x: 0.1, y: 0.8, z: 0.1), // More emphasis on y-axis rotation
                anchor: .center,
                perspective: 0.2 // Reduced perspective for subtlety
            )
            // Secondary 3D effect - slight card bending
            .rotation3DEffect(
                .degrees((!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? -scrollVelocity * 0.15 : scrollVelocity * 0.2) * secondaryRandomFactor * rotationIntensity) : 0),
                axis: (x: 0.3, y: 0.1, z: 0),
                anchor: .trailing, // Anchor to edge to simulate page turning
                perspective: 0.2
            )
            // Horizontal movement dominates (like flipping through cards)
            .offset(
                x: (!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? scrollVelocity * 0.25 : -scrollVelocity * 0.2) * randomFactor * offsetIntensity) : 0,
                y: (!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? scrollVelocity * 0.1 : -scrollVelocity * 0.15) * secondaryRandomFactor * offsetIntensity) : 0
            )
            // Paper-like spring animations
            .animation(
                (!isFocused && isScrolling) ?
                    .spring(response: 0.35, dampingFraction: 0.7).repeatForever(autoreverses: true) :
                    ((!isFocused && windingDown) ?
                        .spring(response: CardDesign.Animation.windDownDuration * 0.6,
                                dampingFraction: CardDesign.Animation.windDownDamping + 0.1) :
                        .easeOut(duration: 0.2)),
                value: animate
            )
            .onChange(of: isScrolling) { _, newValue in
                if newValue && !isFocused {
                    animate = true
                    windingDown = false
                    animationIntensity = 1.0
                    rotationIntensity = 1.0
                    offsetIntensity = 1.0
                } else {
                    windingDown = true
                    
                    // More paper-like wind down with elasticity
                    withAnimation(.spring(response: CardDesign.Animation.windDownDuration * 0.5,
                                        dampingFraction: CardDesign.Animation.windDownDamping + 0.15)) {
                        rotationIntensity = 0.0
                    }
                    
                    withAnimation(.spring(response: CardDesign.Animation.windDownDuration * 0.8,
                                        dampingFraction: CardDesign.Animation.windDownDamping + 0.1)) {
                        offsetIntensity = 0.0
                        animationIntensity = 0.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + CardDesign.Animation.windDownDuration * 1.0) {
                        if !isScrolling {
                            animate = false
                            windingDown = false
                        }
                    }
                }
            }
            .onChange(of: isFocused) { _, newValue in
                if newValue {
                    animate = false
                    windingDown = false
                    animationIntensity = 0.0
                    rotationIntensity = 0.0
                    offsetIntensity = 0.0
                }
            }
            .onAppear {
                // Less extreme random values for more consistent card behavior
                randomFactor = Double.random(in: -0.5...0.5)
                secondaryRandomFactor = Double.random(in: -0.3...0.3)
            }
    }
}

/// Even more subtle breathing animation that mimics paper settling
struct BreathingAnimation: ViewModifier {
    let isFocused: Bool
    let isScrolling: Bool
    @State private var isAnimating = false
    @State private var randomDirection = Double.random(in: -0.6...0.6)
    
    func body(content: Content) -> some View {
        content
            // More subtle scale effect - barely perceptible
            .scaleEffect(isAnimating ? 1.0025 : 1.0)
            // Very subtle paper-like settling movement
            .rotation3DEffect(
                .degrees(isAnimating ? 0.12 * randomDirection : -0.08 * randomDirection),
                axis: (x: 0.1 * randomDirection, y: 1, z: 0),
                anchor: .center,
                perspective: 0.2
            )
            // Secondary slight bending effect
            .rotation3DEffect(
                .degrees(isAnimating ? -0.1 * randomDirection : 0.06 * randomDirection),
                axis: (x: 1, y: 0.2 * randomDirection, z: 0),
                anchor: .center,
                perspective: 0.2
            )
            // Paper-like slow breathing with subtle spring
            .animation(
                isScrolling && !isFocused ?
                    Animation.spring(response: 0.9 + (randomDirection * 0.2),
                                    dampingFraction: 0.7).repeatForever(autoreverses: true) :
                    Animation.easeOut(duration: 0.2),
                value: isAnimating
            )
            .onChange(of: isScrolling) { _, newValue in
                if newValue && !isFocused {
                    isAnimating = true
                } else {
                    isAnimating = false
                }
            }
            .onChange(of: isFocused) { _, newValue in
                if newValue {
                    isAnimating = false
                }
            }
            .onAppear {
                randomDirection = Double.random(in: -0.6...0.6)
                isAnimating = isScrolling && !isFocused
            }
    }
}
