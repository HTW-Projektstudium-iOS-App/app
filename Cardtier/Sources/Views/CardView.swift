// Sources/Cardtier/Views/CardView.swift
import SwiftUI

/// Defines different card presentation styles
/// Each style represents a specific card design for front and back sides
public enum CardDesignStyle {
  case modernFront  // Modern design for the front side
  case modernBack  // Modern design for the back side
  case minimalFront  // Minimal design for the front side
  case minimalBack  // Minimal design for the back side
  // More styles can be added here for future design options
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
      // Calculate card size based on available width
      let cardWidth = min(
        geometry.size.width * CardDesign.Layout.cardWidthMultiplier, CardDesign.Layout.maxCardWidth)
      let cardHeight = cardWidth / CardDesign.Layout.cardAspectRatio

      ZStack {
        // Front side of the card - using style from card model
        // Becomes invisible and rotates when flipped
        cardFace(style: designStyleForCard(isFront: true))
          .opacity(isFlipped ? 0 : 1)
          .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.3
          )

        // Back side of the card - using style from card model
        // Becomes visible and rotates into view when flipped
        cardFace(style: designStyleForCard(isFront: false))
          .opacity(isFlipped ? 1 : 0)
          .rotation3DEffect(
            .degrees(isFlipped ? 0 : -180),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.3
          )
      }
      .frame(width: cardWidth, height: cardHeight)
      .position(x: geometry.size.width / 2, y: geometry.size.height / 2)  // Center in container
      .scaleEffect(isFocused ? CardDesign.Layout.focusedScale : 1.0)  // Slightly enlarge focused card
      .blur(
        radius: isAnyCardFocused && !isFocused
          ? CardDesign.Effects.unfocusedBlur : CardDesign.Effects.focusedBlur
      )
      .brightness(
        isAnyCardFocused
          ? (isFocused
            ? CardDesign.Effects.focusedBrightness : CardDesign.Effects.unfocusedBrightness) : 0
      )
      .offset(y: stackCollapseOffset)  // Move unfocused cards down
      .onTapGesture {
        if isFocused {
          // If already focused, flip the card
          withAnimation(flipAnimation) {
            isFlipped.toggle()
          }
        } else {
          // If not focused, make this card the focused one
          withAnimation(selectionAnimation) {
            focusedCardID = card.id
          }
        }
      }
      .onChange(of: focusedCardID) { oldID, newID in
        // Reset flip state when focus changes to a different card
        if newID != card.id {
          isFlipped = false
        }
      }
      .sheet(isPresented: $showInfo) {
        // Display detailed info sheet when showInfo is true
        CardInfoSheet(card: card, isPresented: $showInfo)
      }
    }
  }

  /// Creates a card face with the specified style
  /// Includes styling like background, shadow, and content based on design style
  private func cardFace(style: CardDesignStyle) -> some View {
    RoundedRectangle(cornerRadius: CardDesign.Layout.cornerRadius)
      .fill(card.style.primaryColor)  // Use card's primary color for background
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
          print("Secondary color: \(secondary.toHex)")
        }
      }
  }

  /// Returns the appropriate content view for the given card style
  /// Each style is implemented as a separate view component for modularity
  @ViewBuilder
  private func cardContentForStyle(_ style: CardDesignStyle) -> some View {
    switch style {
    case .modernFront:
      ModernFrontCardContent(card: card, showInfoAction: { showInfo = true })
    case .modernBack:
      ModernBackCardContent(card: card, showInfoAction: { showInfo = true })
    case .minimalFront:
      MinimalFrontCardContent(card: card, showInfoAction: { showInfo = true })
    case .minimalBack:
      MinimalBackCardContent(card: card, showInfoAction: { showInfo = true })
    }
  }
}

/// Modern design for front card face
/// Features name, title, and company with left-aligned layout
private struct ModernFrontCardContent: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: CardDesign.Padding.large)

      VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
        Text(card.name)
          .font(CardDesign.Typography.titleFont)
          .bold()
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

        if let title = card.title {
          Text(title)
            .font(CardDesign.Typography.headlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
        }

        if let company = card.company {
          Text(company)
            .font(CardDesign.Typography.subheadlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            .padding(.top, CardDesign.Padding.small / 2)
        }
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardDesign.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardDesign.Padding.standard)
  }
}

/// Modern design for back card face
/// Features contact information, address, and slogan with left-aligned layout
private struct ModernBackCardContent: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
        if let company = card.company {
          Text(company)
            .font(CardDesign.Typography.headlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }

        if let role = card.role {
          Text(role)
            .font(CardDesign.Typography.subheadlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
        }

        if card.contactInformation.hasAnyInformation {
          VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
            if let email = card.contactInformation.email {
              Text(email)
                .font(CardDesign.Typography.footnoteFont)
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }

            if let phone = card.contactInformation.phoneNumber {
              Text(phone)
                .font(CardDesign.Typography.footnoteFont)
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }
          }
          .padding(.top, CardDesign.Padding.small)
        }

        if let address = card.businessAddress?.formattedAddress {
          Text(address)
            .font(CardDesign.Typography.footnoteFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            .padding(.top, CardDesign.Padding.small / 2)
        }

        if let slogan = card.slogan {
          Text("\"\(slogan)\"")
            .font(CardDesign.Typography.captionFont)
            .italic()
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
            .padding(.top, CardDesign.Padding.small)
        }
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardDesign.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardDesign.Padding.standard)
  }
}

/// Minimal design for front card face
/// Simplified, centered layout with just name and title
private struct MinimalFrontCardContent: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Spacer()

      Text(card.name)
        .font(CardDesign.Typography.titleFont)
        .bold()
        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

      if let title = card.title {
        Text(title)
          .font(CardDesign.Typography.subheadlineFont)
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardDesign.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardDesign.Padding.standard)
  }
}

private struct MinimalBackCardContent: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Spacer()

      if let company = card.company {
        Text(company)
          .font(CardDesign.Typography.headlineFont)
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
      }

      if let email = card.contactInformation.email {
        Text(email)
          .font(CardDesign.Typography.captionFont)
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
          .padding(.top, CardDesign.Padding.small)
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardDesign.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardDesign.Padding.standard)
  }
}

/// Sheet displaying detailed metadata about a business card
/// Appears when user taps info button
private struct CardInfoSheet: View {
  /// The card to display information for
  let card: Card

  /// Binding to control sheet presentation
  @Binding var isPresented: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: CardDesign.Padding.large) {
      // Header with name
      Text(card.name)
        .font(CardDesign.Typography.headlineFont)
        .foregroundColor(CardDesign.Colors.primary)

      // Contact information section - only displayed if information exists
      if card.contactInformation.hasAnyInformation {
        Group {
          Text("Contact Information")
            .font(CardDesign.Typography.subheadlineFont)
            .bold()
            .foregroundColor(CardDesign.Colors.primary)

          // List of contact details
          VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
            if let email = card.contactInformation.email {
              Text("Email: \(email)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let phone = card.contactInformation.phoneNumber {
              Text("Phone: \(phone)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let fax = card.contactInformation.faxNumber {
              Text("Fax: \(fax)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let website = card.contactInformation.websiteURL {
              Text("Website: \(website.absoluteString)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let linkedin = card.contactInformation.linkedInURL {
              Text("LinkedIn: \(linkedin.absoluteString)")
                .foregroundColor(CardDesign.Colors.primary)
            }
          }
          Divider()  // Visual separator
        }
      }

      // Address information - only displayed if information exists
      if let address = card.businessAddress, address.hasAnyInformation {
        Group {
          Text("Business Address")
            .font(CardDesign.Typography.subheadlineFont)
            .bold()
            .foregroundColor(CardDesign.Colors.primary)

          Text(address.formattedAddress ?? "")
            .foregroundColor(CardDesign.Colors.primary)

          Divider()  // Visual separator
        }
      }

      // Collection metadata - when and where the card was collected
      Group {
        Text("Collection Data")
          .font(CardDesign.Typography.subheadlineFont)
          .bold()
          .foregroundColor(CardDesign.Colors.primary)

        Text("Date: \(card.collectionDate.formatted(date: .long, time: .shortened))")
          .foregroundColor(CardDesign.Colors.primary)

        Text(
          "Location: \(card.collectionLocation.latitude, specifier: "%.4f"), \(card.collectionLocation.longitude, specifier: "%.4f")"
        )
        .foregroundColor(CardDesign.Colors.primary)
      }

      Spacer()  // Push content to top, button to bottom

      // Close button
      Button("Close") {
        isPresented = false
      }
      .frame(maxWidth: .infinity)  // Full width button
      .padding(.vertical, CardDesign.Padding.medium)
      .background(CardDesign.Colors.accent)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .padding(CardDesign.Padding.standard)  // Padding around all content
    .background(Color(.systemBackground))  // System background color for light/dark mode
  }
}
