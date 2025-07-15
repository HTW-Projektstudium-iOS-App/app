import SwiftUI

enum CardSide { case front, back }

/// Displays a single business card that can be flipped and shows metadata
/// This view handles the main card presentation, animations, and interactions
/// TODO: add very slight corner radius
struct CardView: View {
  let card: Card

  @Binding var focusedCardID: UUID?
  private var isFocused: Bool { focusedCardID == card.id }
  private var isAnyCardFocused: Bool { focusedCardID != nil }

  let isFlipped: Bool
  let isScrolling: Bool
  let scrollVelocity: CGFloat

  /// Additional vertical offset for non-focused cards when a card is selected
  /// Creates a "stack collapse" effect where unfocused cards move down
  private var stackCollapseOffset: CGFloat {
    isAnyCardFocused && !isFocused ? 100 : 0
  }

  var body: some View {
    Rectangle()
      .fill(card.style.primaryColor)
      .shadow(radius: isFocused ? 8 : 4, x: 0, y: isFocused ? 4 : 2)
      .overlay {
        switch card.style.designStyle {
        case .modern where isFlipped:
          ModernCard(card: card, side: .back)
            .scaleEffect(x: -1, y: 1, anchor: .center)
        case .modern:
          ModernCard(card: card, side: .front)
        case .minimal where isFlipped:
          MinimalCard(card: card, side: .back)
            .scaleEffect(x: -1, y: 1, anchor: .center)
        case .minimal:
          MinimalCard(card: card, side: .front)
        case .traditional where isFlipped:
          TraditionalCard(card: card, side: .back)
            .scaleEffect(x: -1, y: 1, anchor: .center)
        case .traditional:
          TraditionalCard(card: card, side: .front)
        }
      }
      .overlay(
        Rectangle()
          .stroke(Color.black.opacity(0.15), lineWidth: 0.7)
      )
      .modifier(
        ScrollingAnimation(
          isScrolling: isScrolling,
          scrollVelocity: scrollVelocity,
          isFocused: isFocused
        )
      )
      .modifier(BreathingAnimation(isFocused: isFocused, isScrolling: isScrolling))
      .rotation3DEffect(
        .degrees(isFlipped ? 180 : 0),
        axis: (x: 0, y: 1, z: 0),
        perspective: 0.5
      )
      .scaleEffect(isFocused ? 1.05 : 1.0)
      .blur(radius: isAnyCardFocused && !isFocused ? 5 : 0)
      .brightness(isAnyCardFocused ? (isFocused ? 0.03 : -0.1) : 0)
      .offset(y: stackCollapseOffset)
  }
}
