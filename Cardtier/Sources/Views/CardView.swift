// Sources/Cardtier/Views/CardView.swift
import SwiftUI

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

    /// Whether the card stack is currently scrolling (for scroll-based animation)
    @EnvironmentObject private var viewModel: CardStackViewModel

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
            let cardWidth = min(geometry.size.width * CardDesign.Layout.cardWidthMultiplier, CardDesign.Layout.maxCardWidth)
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
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center in container
            .scaleEffect(isFocused ? CardDesign.Layout.focusedScale : 1.0) // Slightly enlarge focused card
            .blur(radius: isAnyCardFocused && !isFocused ? CardDesign.Effects.unfocusedBlur : CardDesign.Effects.focusedBlur)
            .brightness(isAnyCardFocused ? (isFocused ? CardDesign.Effects.focusedBrightness : CardDesign.Effects.unfocusedBrightness) : 0)
            .offset(y: stackCollapseOffset) // Move unfocused cards down
            .onTapGesture {
                if isFocused {
                    // If already focused, flip the card
                    withAnimation(flipAnimation) {
                        isFlipped.toggle()
                    }
                } else {
                    // If not focused, make this card the focused one
                    withAnimation(selectionAnimation) {
                        // Stop scrolling animations when focusing a card
                        viewModel.isScrolling = false
                        viewModel.scrollVelocity = 0
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
        ZStack {
            // Background shadow for depth
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.black.opacity(0.08))
                .offset(y: 3)
                .blur(radius: 5)
            
            // Main card with enhanced 3D effects - make fully opaque
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                card.style.primaryColor,
                                card.style.primaryColor // Remove opacity to make fully opaque
                            ]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // Add a solid background first to ensure opacity
                    RoundedRectangle(cornerRadius: 0)
                        .fill(card.style.primaryColor)
                )
                .overlay(
                    // Enhanced inner light reflection
                    RoundedRectangle(cornerRadius: 0)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.35), .clear]),
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                )
                .overlay(
                    cardContentForStyle(style)
                )
                .overlay(
                    // Status indicator 
                    Rectangle()
                        .fill(Color.clear) // Use clear color instead of opacity
                )
                .overlay(
                    // Card border with enhanced contrast
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.black.opacity(0.15), lineWidth: 0.7)
                )
                // Only apply stack collapse offset and rotation when scrolling
                .offset(y: (isAnyCardFocused && !isFocused) ? CardDesign.Layout.unfocusedOffset * 0.3 : 0)
                .modifier(ScrollingAnimation(
                    isScrolling: viewModel.isScrolling,
                    scrollVelocity: viewModel.scrollVelocity,
                    isFocused: isFocused
                ))
                .modifier(BreathingAnimation(isFocused: isFocused, isScrolling: viewModel.isScrolling))
        }
        // Enhanced shadow effect
        .shadow(
            color: Color.black.opacity(isFocused ? 0.25 : 0.15),
            radius: isFocused ? 12 : 8,
            x: 0,
            y: isFocused ? 6 : 4
        )
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
