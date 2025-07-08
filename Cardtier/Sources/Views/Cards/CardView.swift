import SwiftUI

public enum CardDesignStyle {
  case modernFront
  case modernBack
  case minimalFront
  case minimalBack
}

/// Displays a single business card that can be flipped and shows metadata
/// This view handles the main card presentation, animations, and interactions
public struct CardView: View {
  /// The card data model containing all business card information
  let card: Card

  /// Whether the card is currently flipped to show back side
  /// True = showing back side, False = showing front side
  @Binding var isFlipped: Bool

  /// Whether the detailed metadata sheet is currently displayed
  @Binding var showInfo: Bool

  /// ID of the currently focused/selected card (if any)
  /// When a card is focused, it receives visual emphasis and interaction focus
  @Binding var focusedCardID: UUID?

  /// Animation for card flipping transitions
  private let flipAnimation = CardDesign.Animation.flipTransition

  /// Animation for card selection/deselection
  private let selectionAnimation = CardDesign.Animation.selectionTransition

  /// Determines if this specific card is currently focused
  /// Compares this card's ID with the focused card ID
  private var isFocused: Bool {
    focusedCardID == card.id
  }

  /// Determines if any card in the collection is currently focused
  /// Used to apply visual changes to non-focused cards
  private var isAnyCardFocused: Bool {
    focusedCardID != nil
  }

  /// Additional vertical offset for non-focused cards when a card is selected
  /// Creates a "stack collapse" effect where unfocused cards move down
  private var stackCollapseOffset: CGFloat {
    isAnyCardFocused && !isFocused ? CardDesign.Layout.unfocusedOffset : 0
  }

  /// Creates a new card view
  /// - Parameters:
  ///   - card: The card data to display
  ///   - isFlipped: Binding to track if card is showing back side
  ///   - showInfo: Binding to track if metadata sheet is visible
  ///   - focusedCardID: Binding to the currently focused card ID
  public init(
    card: Card,
    isFlipped: Binding<Bool>,
    showInfo: Binding<Bool>,
    focusedCardID: Binding<UUID?>
  ) {
    self.card = card
    self._isFlipped = isFlipped
    self._showInfo = showInfo
    self._focusedCardID = focusedCardID
  }

  /// Determines the appropriate CardDesignStyle based on the card's style property
  /// - Parameter isFront: Whether this is for the front side of the card
  /// - Returns: The corresponding CardDesignStyle
  private func designStyleForCard(isFront: Bool) -> CardDesignStyle {
    switch card.style.designStyle {
    case .modern:
      return isFront ? .modernFront : .modernBack
    case .minimal:
      return isFront ? .minimalFront : .minimalBack
    }
  }

  public var body: some View {
    GeometryReader { geometry in
      let cardWidth = min(
        geometry.size.width * CardDesign.Layout.cardWidthMultiplier, CardDesign.Layout.maxCardWidth)
      let cardHeight = cardWidth / CardDesign.Layout.cardAspectRatio

      ZStack {
        cardFace(style: designStyleForCard(isFront: true))
          .opacity(isFlipped ? 0 : 1)
          .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.3
          )

        cardFace(style: designStyleForCard(isFront: false))
          .opacity(isFlipped ? 1 : 0)
          .rotation3DEffect(
            .degrees(isFlipped ? 0 : -180),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.3
          )
      }
      .frame(width: cardWidth, height: cardHeight)
      .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
      .scaleEffect(isFocused ? CardDesign.Layout.focusedScale : 1.0)
      .blur(
        radius: isAnyCardFocused && !isFocused
          ? CardDesign.Effects.unfocusedBlur : CardDesign.Effects.focusedBlur
      )
      .brightness(
        isAnyCardFocused
          ? (isFocused
            ? CardDesign.Effects.focusedBrightness : CardDesign.Effects.unfocusedBrightness) : 0
      )
      .offset(y: stackCollapseOffset)
      .onTapGesture {
        if isFocused {
          withAnimation(flipAnimation) {
            isFlipped.toggle()
          }
        } else {
          withAnimation(selectionAnimation) {
            focusedCardID = card.id
          }
        }
      }
      .onChange(of: focusedCardID) { _, newID in
        if newID != card.id {
          isFlipped = false
        }
      }
      .sheet(isPresented: $showInfo) {
        CardInfoSheet(card: card, isPresented: $showInfo)
      }
    }
  }

  /// Creates a card face with the specified style
  /// Includes styling like background, shadow, and content based on design style
  private func cardFace(style: CardDesignStyle) -> some View {
    RoundedRectangle(cornerRadius: CardDesign.Layout.cornerRadius)
      .fill(card.style.primaryColor)
      .shadow(
        radius: isFocused
          ? CardDesign.Effects.focusedShadowRadius : CardDesign.Effects.unfocusedShadowRadius,
        x: 0,
        y: isFocused ? CardDesign.Effects.focusedShadowY : CardDesign.Effects.unfocusedShadowY
      )
      .overlay(
        cardContentForStyle(style)
      )
      .overlay(
        Rectangle()
          .fill(
            card.style.secondaryColor?.opacity(
              isAnyCardFocused && !isFocused ? CardDesign.Effects.dimOpacity : 0)
              ?? CardDesign.Colors.primary.opacity(
                isAnyCardFocused && !isFocused ? CardDesign.Effects.dimOpacity : 0))
      )
      .onAppear {
        print("Card: \(card.name)")
        if let secondary = card.style.secondaryColor {
          print("Secondary color: \(secondary.hexString)")
        }
      }
  }

  /// Returns the appropriate content view for the given card style
  /// Each style is implemented as a separate view component for modularity
  @ViewBuilder
  private func cardContentForStyle(_ style: CardDesignStyle) -> some View {
    switch style {
    case .modernFront:
      ModernCardFront(card: card, showInfoAction: { showInfo = true })
    case .modernBack:
      ModernCardBack(card: card, showInfoAction: { showInfo = true })
    case .minimalFront:
      MinimalCardFront(card: card, showInfoAction: { showInfo = true })
    case .minimalBack:
      MinimalCardBack(card: card, showInfoAction: { showInfo = true })
    }
  }
}
