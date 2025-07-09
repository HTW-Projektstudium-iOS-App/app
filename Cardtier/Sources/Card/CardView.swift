import SwiftUI

enum CardDesignStyle {
  case modernFront
  case modernBack
  case minimalFront
  case minimalBack
}

/// Displays a single business card that can be flipped and shows metadata
/// This view handles the main card presentation, animations, and interactions
struct CardView: View {
  /// The card data model containing all business card information
  let card: Card

  /// Whether the card is currently flipped to show back side
  /// True = showing back side, False = showing front side
  @State var isFlipped: Bool = false

  /// Whether the detailed metadata sheet is currently displayed
  @State var isShowingInfo: Bool = false

  /// ID of the currently focused/selected card (if any)
  /// When a card is focused, it receives visual emphasis and interaction focus
  @Binding var focusedCardID: UUID?

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
    isAnyCardFocused && !isFocused ? CardConstants.Layout.unfocusedOffset : 0
  }

  /// Creates a new card view
  /// - Parameters:
  ///   - card: The card data to display
  ///   - focusedCardID: Binding to the currently focused card ID
  init(
    card: Card,
    focusedCardID: Binding<UUID?>
  ) {
    self.card = card
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

  var body: some View {
    GeometryReader { geometry in
      let cardWidth = min(
        geometry.size.width * CardConstants.Layout.cardWidthMultiplier,
        CardConstants.Layout.maxCardWidth)
      let cardHeight = cardWidth / CardConstants.Layout.cardAspectRatio

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
      .scaleEffect(isFocused ? CardConstants.Layout.focusedScale : 1.0)
      .blur(
        radius: isAnyCardFocused && !isFocused
          ? CardConstants.Effects.unfocusedBlur : CardConstants.Effects.focusedBlur
      )
      .brightness(
        isAnyCardFocused
          ? (isFocused
            ? CardConstants.Effects.focusedBrightness : CardConstants.Effects.unfocusedBrightness)
          : 0
      )
      .offset(y: stackCollapseOffset)
      .onTapGesture {
        if isFocused {
          withAnimation(.cardFlip) {
            isFlipped.toggle()
          }
        } else {
          withAnimation(.cardSelection) {
            focusedCardID = card.id
          }
        }
      }
      .onChange(of: focusedCardID) { _, newID in
        if newID != card.id {
          isFlipped = false
        }
      }
      .sheet(isPresented: $isShowingInfo) {
        CardInfoSheet(card: card, isPresented: $isShowingInfo)
      }
    }
  }

  /// Creates a card face with the specified style
  /// Includes styling like background, shadow, and content based on design style
  private func cardFace(style: CardDesignStyle) -> some View {
    RoundedRectangle(cornerRadius: CardConstants.Layout.cornerRadius)
      .fill(card.style.primaryColor)
      .shadow(
        radius: isFocused
          ? CardConstants.Effects.focusedShadowRadius : CardConstants.Effects.unfocusedShadowRadius,
        x: 0,
        y: isFocused ? CardConstants.Effects.focusedShadowY : CardConstants.Effects.unfocusedShadowY
      )
      .overlay(
        cardContentForStyle(style)
      )
      .overlay(
        Rectangle()
          .fill(
            card.style.secondaryColor?.opacity(
              isAnyCardFocused && !isFocused ? CardConstants.Effects.dimOpacity : 0)
              ?? CardConstants.Colors.primary.opacity(
                isAnyCardFocused && !isFocused ? CardConstants.Effects.dimOpacity : 0))
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
      ModernCardFront(card: card, showInfoAction: { isShowingInfo = true })
    case .modernBack:
      ModernCardBack(card: card, showInfoAction: { isShowingInfo = true })
    case .minimalFront:
      MinimalCardFront(card: card, showInfoAction: { isShowingInfo = true })
    case .minimalBack:
      MinimalCardBack(card: card, showInfoAction: { isShowingInfo = true })
    }
  }
}
