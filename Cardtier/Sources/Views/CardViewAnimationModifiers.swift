import SwiftUI

/// Modifier for animating cards during scrolling with subtle 3D effects, rotations, and offsets.
struct ScrollingAnimation: ViewModifier {
    let isScrolling: Bool
    let scrollVelocity: CGFloat
    let isFocused: Bool
    @State private var animate = false
    @State private var randomFactor = Double.random(in: CardViewAnimationConstants.randomFactorMin...CardViewAnimationConstants.randomFactorMax)
    @State private var secondaryRandomFactor = Double.random(in: CardViewAnimationConstants.secondaryRandomFactorMin...CardViewAnimationConstants.secondaryRandomFactorMax)
    @State private var windingDown = false
    @State private var animationIntensity: Double = 1.0
    @State private var rotationIntensity: Double = 1.0
    @State private var offsetIntensity: Double = 1.0

    func body(content: Content) -> some View {
        content
            // Slight opacity and scale changes for non-focused, moving cards
            .opacity((!isFocused && (isScrolling || windingDown)) ?
                CardViewAnimationConstants.opacityBase + (CardViewAnimationConstants.opacityIntensity * animationIntensity) : 1.0)
            .scaleEffect((!isFocused && (isScrolling || windingDown)) ?
                CardViewAnimationConstants.scaleBase + (CardViewAnimationConstants.scaleIntensity * (1.0 - animationIntensity)) : 1.0)
            // Main rotation and 3D effects for flipping and bending
            .rotationEffect(.degrees((!isFocused && (isScrolling || windingDown)) ?
                ((animate ? scrollVelocity * CardViewAnimationConstants.rotationMultiplier1 : -scrollVelocity * CardViewAnimationConstants.rotationMultiplier2) * randomFactor * rotationIntensity) : 0))
            .rotation3DEffect(
                .degrees((!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier1 : -scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier2) * randomFactor * rotationIntensity) : 0),
                axis: (
                    x: CGFloat(CardViewAnimationConstants.rotation3DAxis1.x),
                    y: CGFloat(CardViewAnimationConstants.rotation3DAxis1.y),
                    z: CGFloat(CardViewAnimationConstants.rotation3DAxis1.z)
                ),
                anchor: CardViewAnimationConstants.rotation3DAnchor,
                perspective: CardViewAnimationConstants.rotation3DPerspective
            )
            .rotation3DEffect(
                .degrees((!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? -scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier3 : scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier4) * secondaryRandomFactor * rotationIntensity) : 0),
                axis: (
                    x: CGFloat(CardViewAnimationConstants.rotation3DAxis2.x),
                    y: CGFloat(CardViewAnimationConstants.rotation3DAxis2.y),
                    z: CGFloat(CardViewAnimationConstants.rotation3DAxis2.z)
                ),
                anchor: CardViewAnimationConstants.rotation3DAnchorTrailing,
                perspective: CardViewAnimationConstants.rotation3DPerspective
            )
            // Subtle offset for movement
            .offset(
                x: (!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? scrollVelocity * CardViewAnimationConstants.offsetXMultiplier1 : -scrollVelocity * CardViewAnimationConstants.offsetXMultiplier2) * randomFactor * offsetIntensity) : 0,
                y: (!isFocused && (isScrolling || windingDown)) ?
                    ((animate ? scrollVelocity * CardViewAnimationConstants.offsetYMultiplier1 : -scrollVelocity * CardViewAnimationConstants.offsetYMultiplier2) * secondaryRandomFactor * offsetIntensity) : 0
            )
            // Spring animation
            .animation(
                (!isFocused && isScrolling) ?
                    .spring(response: CardViewAnimationConstants.animationSpringResponse, dampingFraction: CardViewAnimationConstants.animationSpringDamping).repeatForever(autoreverses: true) :
                    ((!isFocused && windingDown) ?
                        .spring(response: CardDesign.Animation.windDownDuration * CardViewAnimationConstants.windDownMultiplier1,
                                dampingFraction: CardDesign.Animation.windDownDamping + CardViewAnimationConstants.windDownDampingOffset1) :
                        .easeOut(duration: CardViewAnimationConstants.animationEaseOutDuration)),
                value: animate
            )
            // Handle animation state changes
            .onChange(of: isScrolling) { _, newValue in
                if newValue && !isFocused {
                    animate = true
                    windingDown = false
                    animationIntensity = 1.0
                    rotationIntensity = 1.0
                    offsetIntensity = 1.0
                } else {
                    windingDown = true
                    withAnimation(.spring(response: CardDesign.Animation.windDownDuration * CardViewAnimationConstants.windDownMultiplier2,
                                         dampingFraction: CardDesign.Animation.windDownDamping + CardViewAnimationConstants.windDownDampingOffset2)) {
                        rotationIntensity = 0.0
                    }
                    withAnimation(.spring(response: CardDesign.Animation.windDownDuration * CardViewAnimationConstants.windDownMultiplier3,
                                         dampingFraction: CardDesign.Animation.windDownDamping + CardViewAnimationConstants.windDownDampingOffset1)) {
                        offsetIntensity = 0.0
                        animationIntensity = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + CardDesign.Animation.windDownDuration * CardViewAnimationConstants.windDownMultiplier4) {
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
                randomFactor = Double.random(in: CardViewAnimationConstants.randomFactorMin...CardViewAnimationConstants.randomFactorMax)
                secondaryRandomFactor = Double.random(in: CardViewAnimationConstants.secondaryRandomFactorMin...CardViewAnimationConstants.secondaryRandomFactorMax)
            }
    }
}

/// Modifier for a subtle breathing animation, mimicking paper settling.
struct BreathingAnimation: ViewModifier {
    let isFocused: Bool
    let isScrolling: Bool
    @State private var isAnimating = false
    @State private var randomDirection = Double.random(in: CardViewAnimationConstants.breathingRandomDirectionMin...CardViewAnimationConstants.breathingRandomDirectionMax)

    func body(content: Content) -> some View {
        content
            // Barely perceptible scale and 3D effects
            .scaleEffect(isAnimating ? CardViewAnimationConstants.breathingScale : 1.0)
            .rotation3DEffect(
                .degrees(isAnimating ? CardViewAnimationConstants.breathingRotation1 * randomDirection : CardViewAnimationConstants.breathingRotation2 * randomDirection),
                axis: (
                    x: CGFloat(CardViewAnimationConstants.breathingAxis1.x),
                    y: CGFloat(CardViewAnimationConstants.breathingAxis1.y),
                    z: CGFloat(CardViewAnimationConstants.breathingAxis1.z)
                ),
                anchor: .center,
                perspective: CardViewAnimationConstants.breathingPerspective
            )
            .rotation3DEffect(
                .degrees(isAnimating ? CardViewAnimationConstants.breathingRotation3 * randomDirection : CardViewAnimationConstants.breathingRotation4 * randomDirection),
                axis: (
                    x: CGFloat(CardViewAnimationConstants.breathingAxis2.x),
                    y: CGFloat(CardViewAnimationConstants.breathingAxis2.y),
                    z: CGFloat(CardViewAnimationConstants.breathingAxis2.z)
                ),
                anchor: .center,
                perspective: CardViewAnimationConstants.breathingPerspective
            )
            // Slow, springy breathing animation
            .animation(
                isScrolling && !isFocused ?
                    Animation.spring(response: CardViewAnimationConstants.breathingSpringResponseBase + (randomDirection * CardViewAnimationConstants.breathingSpringResponseRange),
                                    dampingFraction: CardViewAnimationConstants.breathingSpringDamping).repeatForever(autoreverses: true) :
                    Animation.easeOut(duration: CardViewAnimationConstants.breathingEaseOutDuration),
                value: isAnimating
            )
            // Animation state changes
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
                randomDirection = Double.random(in: CardViewAnimationConstants.breathingRandomDirectionMin...CardViewAnimationConstants.breathingRandomDirectionMax)
                isAnimating = isScrolling && !isFocused
            }
    }
}
