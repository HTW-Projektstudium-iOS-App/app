import SwiftUI

/// Modifier for animating cards during scrolling with subtle 3D effects, rotations, and offsets.
struct ScrollingAnimation: ViewModifier {
  let isScrolling: Bool
  let scrollVelocity: CGFloat
  let isFocused: Bool
  @State private var animate = false
  @State private var randomFactor = Double.random(
    in: CardViewAnimationConstants.randomFactorMin...CardViewAnimationConstants.randomFactorMax)
  @State private var secondaryRandomFactor = Double.random(
    in: CardViewAnimationConstants
      .secondaryRandomFactorMin...CardViewAnimationConstants.secondaryRandomFactorMax)
  @State private var windingDown = false
  @State private var animationIntensity: Double = 1.0
  @State private var rotationIntensity: Double = 1.0
  @State private var offsetIntensity: Double = 1.0

  // swiftlint:disable:next function_body_length
  func body(content: Content) -> some View {
    content
      // Slight opacity and scale changes for non-focused, moving cards
      .opacity(
        (!isFocused && (isScrolling || windingDown))
          ? CardViewAnimationConstants.opacityBase
            + (CardViewAnimationConstants.opacityIntensity * animationIntensity) : 1.0
      )
      .scaleEffect(
        (!isFocused && (isScrolling || windingDown))
          ? CardViewAnimationConstants.scaleBase
            + (CardViewAnimationConstants.scaleIntensity * (1.0 - animationIntensity)) : 1.0
      )
      // Main rotation and 3D effects for flipping and bending
      .rotationEffect(
        .degrees(
          (!isFocused && (isScrolling || windingDown))
            ? ((animate
              ? scrollVelocity * CardViewAnimationConstants.rotationMultiplier1
              : -scrollVelocity * CardViewAnimationConstants.rotationMultiplier2) * randomFactor
              * rotationIntensity) : 0)
      )
      .rotation3DEffect(
        .degrees(
          (!isFocused && (isScrolling || windingDown))
            ? ((animate
              ? scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier1
              : -scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier2) * randomFactor
              * rotationIntensity) : 0),
        axis: (
          x: CGFloat(CardViewAnimationConstants.rotation3DAxis1.x),
          y: CGFloat(CardViewAnimationConstants.rotation3DAxis1.y),
          z: CGFloat(CardViewAnimationConstants.rotation3DAxis1.z)
        ),
        anchor: CardViewAnimationConstants.rotation3DAnchor,
        perspective: CardViewAnimationConstants.rotation3DPerspective
      )
      .rotation3DEffect(
        .degrees(
          (!isFocused && (isScrolling || windingDown))
            ? ((animate
              ? -scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier3
              : scrollVelocity * CardViewAnimationConstants.rotation3DMultiplier4)
              * secondaryRandomFactor * rotationIntensity) : 0),
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
        x: (!isFocused && (isScrolling || windingDown))
          ? ((animate
            ? scrollVelocity * CardViewAnimationConstants.offsetXMultiplier1
            : -scrollVelocity * CardViewAnimationConstants.offsetXMultiplier2) * randomFactor
            * offsetIntensity) : 0,
        y: (!isFocused && (isScrolling || windingDown))
          ? ((animate
            ? scrollVelocity * CardViewAnimationConstants.offsetYMultiplier1
            : -scrollVelocity * CardViewAnimationConstants.offsetYMultiplier2)
            * secondaryRandomFactor * offsetIntensity) : 0
      )
      // Spring animation
      .animation(
        (!isFocused && isScrolling)
          ? .spring(
            response: CardViewAnimationConstants.animationSpringResponse,
            dampingFraction: CardViewAnimationConstants.animationSpringDamping
          ).repeatForever(autoreverses: true)
          : ((!isFocused && windingDown)
            ? .spring(
              response: 0.7 * CardViewAnimationConstants.windDownMultiplier1,
              dampingFraction: 0.65 + CardViewAnimationConstants.windDownDampingOffset1)
            : .easeOut(duration: CardViewAnimationConstants.animationEaseOutDuration)),
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
          withAnimation(
            .spring(
              response: 0.7 * CardViewAnimationConstants.windDownMultiplier2,
              dampingFraction: 0.65 + CardViewAnimationConstants.windDownDampingOffset2)
          ) {
            rotationIntensity = 0.0
          }
          withAnimation(
            .spring(
              response: 0.7 * CardViewAnimationConstants.windDownMultiplier3,
              dampingFraction: 0.65 + CardViewAnimationConstants.windDownDampingOffset1)
          ) {
            offsetIntensity = 0.0
            animationIntensity = 0.0
          }
          DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.7 * CardViewAnimationConstants.windDownMultiplier4
          ) {
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
        randomFactor = Double.random(
          in: CardViewAnimationConstants
            .randomFactorMin...CardViewAnimationConstants.randomFactorMax)
        secondaryRandomFactor = Double.random(
          in: CardViewAnimationConstants
            .secondaryRandomFactorMin...CardViewAnimationConstants.secondaryRandomFactorMax)
      }
  }
}

/// Modifier for a subtle breathing animation, mimicking paper settling.
struct BreathingAnimation: ViewModifier {
  let isFocused: Bool
  let isScrolling: Bool
  @State private var isAnimating = false
  @State private var randomDirection = Double.random(
    in: CardViewAnimationConstants
      .breathingRandomDirectionMin...CardViewAnimationConstants.breathingRandomDirectionMax)

  func body(content: Content) -> some View {
    content
      // Barely perceptible scale and 3D effects
      .scaleEffect(isAnimating ? CardViewAnimationConstants.breathingScale : 1.0)
      .rotation3DEffect(
        .degrees(
          isAnimating
            ? CardViewAnimationConstants.breathingRotation1 * randomDirection
            : CardViewAnimationConstants.breathingRotation2 * randomDirection),
        axis: (
          x: CGFloat(CardViewAnimationConstants.breathingAxis1.x),
          y: CGFloat(CardViewAnimationConstants.breathingAxis1.y),
          z: CGFloat(CardViewAnimationConstants.breathingAxis1.z)
        ),
        anchor: .center,
        perspective: CardViewAnimationConstants.breathingPerspective
      )
      .rotation3DEffect(
        .degrees(
          isAnimating
            ? CardViewAnimationConstants.breathingRotation3 * randomDirection
            : CardViewAnimationConstants.breathingRotation4 * randomDirection),
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
        isScrolling && !isFocused
          ? Animation.spring(
            response: CardViewAnimationConstants.breathingSpringResponseBase
              + (randomDirection * CardViewAnimationConstants.breathingSpringResponseRange),
            dampingFraction: CardViewAnimationConstants.breathingSpringDamping
          ).repeatForever(autoreverses: true)
          : Animation.easeOut(duration: CardViewAnimationConstants.breathingEaseOutDuration),
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
        randomDirection = Double.random(
          in: CardViewAnimationConstants
            .breathingRandomDirectionMin...CardViewAnimationConstants.breathingRandomDirectionMax)
        isAnimating = isScrolling && !isFocused
      }
  }
}

private enum CardViewAnimationConstants {
  static let randomFactorMin: Double = -0.5
  static let randomFactorMax: Double = 0.5
  static let secondaryRandomFactorMin: Double = -0.3
  static let secondaryRandomFactorMax: Double = 0.3
  static let opacityBase: Double = 0.98
  static let opacityIntensity: Double = 0.02
  static let scaleBase: Double = 0.997
  static let scaleIntensity: Double = 0.003
  static let rotationMultiplier1: Double = 0.4
  static let rotationMultiplier2: Double = 0.3
  static let rotation3DMultiplier1: Double = 0.3
  static let rotation3DMultiplier2: Double = 0.2
  static let rotation3DMultiplier3: Double = 0.15
  static let rotation3DMultiplier4: Double = 0.2
  static let offsetXMultiplier1: Double = 0.25
  static let offsetXMultiplier2: Double = 0.2
  static let offsetYMultiplier1: Double = 0.1
  static let offsetYMultiplier2: Double = 0.15
  static let rotation3DAxis1: (x: Double, y: Double, z: Double) = (0.1, 0.8, 0.1)
  static let rotation3DAxis2: (x: Double, y: Double, z: Double) = (0.3, 0.1, 0)
  static let rotation3DAnchor: UnitPoint = .center
  static let rotation3DPerspective: CGFloat = 0.2
  static let rotation3DAnchorTrailing: UnitPoint = .trailing
  static let animationSpringResponse: Double = 0.35
  static let animationSpringDamping: Double = 0.7
  static let animationEaseOutDuration: Double = 0.2
  static let windDownMultiplier1: Double = 0.6
  static let windDownMultiplier2: Double = 0.5
  static let windDownMultiplier3: Double = 0.8
  static let windDownMultiplier4: Double = 1.0
  static let windDownDampingOffset1: Double = 0.1
  static let windDownDampingOffset2: Double = 0.15

  static let breathingRandomDirectionMin: Double = -0.6
  static let breathingRandomDirectionMax: Double = 0.6
  static let breathingScale: CGFloat = 1.0025
  static let breathingRotation1: Double = 0.12
  static let breathingRotation2: Double = -0.08
  static let breathingRotation3: Double = -0.1
  static let breathingRotation4: Double = 0.06
  static let breathingAxis1: (x: Double, y: Double, z: Double) = (0.1, 1, 0)
  static let breathingAxis2: (x: Double, y: Double, z: Double) = (1, 0.2, 0)
  static let breathingPerspective: CGFloat = 0.2
  static let breathingSpringResponseBase: Double = 0.9
  static let breathingSpringResponseRange: Double = 0.2
  static let breathingSpringDamping: Double = 0.7
  static let breathingEaseOutDuration: Double = 0.2
}
