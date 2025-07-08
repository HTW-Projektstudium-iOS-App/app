// Sources/Cardtier/Views/ContentView.swift
import SwiftUI

/// Main view displaying a stack of business cards
/// This is the primary container view that manages card layout and interactions
public struct ContentView: View {
  /// View model managing the card stack data and state
  /// Contains all business cards and tracks their individual states
  @StateObject private var viewModel = CardStackViewModel(withSampleData: true)

  /// Scroll position tracking for the card stack
  @State private var scrollPosition: CGPoint = .zero

  /// Reference to the ScrollViewProxy for programmatic scrolling
  @State private var scrollReader: ScrollViewProxy? = nil

  /// Animation for card stack movement
  /// Spring animation with faster response for a snappy feel
  private let stackAnimation = Animation.spring(
    response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)

  /// Creates the main content view
  /// Empty initializer as the view uses a StateObject for its data
  public init() {}

  public var body: some View {
    // Main container with stacked layout
    // Cards in the stack appear behind the focused card
    ZStack(alignment: .top) {
      // Background stack of cards (scrollable)
      cardStackView

      // Currently focused card (if any)
      // Displayed on top of the stack with special styling
      focusedCardView
    }
    // Use system background color that adapts to light/dark mode
    .background(Color(UIColor.systemGroupedBackground))
    // When a card becomes focused, scroll to the top of the stack
    .onChange(of: viewModel.focusedCardID) { oldValue, newValue in
      if newValue != nil {
        withAnimation(stackAnimation) {
          scrollReader?.scrollTo("stackAnchor", anchor: .top)
        }
      }
    }
  }

  /// The scrollable stack of cards
  /// Contains all cards except the currently focused one
  private var cardStackView: some View {
    // ScrollViewReader provides programmatic scrolling capability
    ScrollViewReader { proxy in
      // Vertical scrolling container without indicators
      ScrollView(.vertical, showsIndicators: false) {
        ZStack(alignment: .top) {
          // Transparent overlay that captures taps to reset focus
          // When tapped outside cards, deselects the currently focused card
          Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
              if viewModel.focusedCardID != nil {
                withAnimation(stackAnimation) {
                  viewModel.resetFocusedCard()
                }
              }
            }

          // Stack of cards in a vertical arrangement
          VStack(spacing: 0) {
            // Invisible spacer that creates room at the top when a card is focused
            // Pushes the card stack down to make space for the focused card
            Color.clear
              .frame(height: viewModel.focusedCardID != nil ? 250 : 0)
              .id("stackAnchor")  // ID for programmatic scrolling

            // Loop through all cards and display them (except the focused one)
            ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
              if card.id != viewModel.focusedCardID {
                // Card view with bindings to track state
                CardView(
                  card: card,
                  isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
                  showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
                  focusedCardID: $viewModel.focusedCardID
                )
                .frame(height: CardDesign.Layout.cardHeight)
                .padding(.horizontal, CardDesign.Layout.horizontalPadding)
                .zIndex(Double(index))  // Stack order based on index
                .offset(y: CGFloat(index) * CardDesign.Layout.cardStackOffset)  // Staggered offset
                // Animation when cards appear/disappear
                .transition(
                  .asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .bottom)).animation(
                      .easeOut(duration: 0.4)),
                    removal: .opacity.combined(with: .move(edge: .top)).animation(
                      .easeIn(duration: 0.35))
                  )
                )
              }
            }
          }
          .padding(.top, CardDesign.Layout.stackTopPadding)
          .animation(stackAnimation, value: viewModel.focusedCardID)  // Animate when focus changes
        }
      }
      // Store ScrollViewProxy for programmatic scrolling
      .onAppear {
        scrollReader = proxy
      }
      // Detect scrolling with gesture to reset focus
      // When user scrolls, any focused card is deselected
      .simultaneousGesture(
        DragGesture(minimumDistance: CardDesign.Layout.dragMinDistance, coordinateSpace: .local)
          .onChanged { _ in
            if !viewModel.isDragging && viewModel.focusedCardID != nil {
              viewModel.isDragging = true
              withAnimation(stackAnimation) {
                viewModel.resetFocusedCard()
              }
            }
          }
          .onEnded { _ in
            viewModel.isDragging = false
          }
      )
    }
  }

  /// The currently focused card, if any
  /// Displayed prominently above the card stack
  private var focusedCardView: some View {
    Group {
      // Only show if there is a focused card
      if let card = viewModel.focusedCard {
        // Card view with bindings to track state
        CardView(
          card: card,
          isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
          showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
          focusedCardID: $viewModel.focusedCardID
        )
        .frame(height: CardDesign.Layout.cardHeight)
        .padding(.horizontal, CardDesign.Layout.horizontalPadding)
        .zIndex(1000)  // Always on top of the stack
        .padding(.top, CardDesign.Layout.focusedCardTopPadding)  // Position at the top
        // Animations for appearance/disappearance
        .transition(
          .asymmetric(
            insertion: AnyTransition.opacity
              .combined(with: .move(edge: .bottom))
              .animation(.easeOut(duration: 0.4)),
            removal: AnyTransition.opacity
              .combined(with: .move(edge: .bottom))
              .animation(.easeIn(duration: 0.35))
          )
        )
        .shadow(radius: 10, x: 0, y: 3)  // Enhanced shadow for depth
        // Slight 3D tilt for better visual presence
        .rotation3DEffect(
          .degrees(1),
          axis: (x: 1.0, y: 0, z: 0),
          anchor: .center,
          perspective: 0.1
        )
        .animation(stackAnimation, value: viewModel.focusedCardID)  // Animate when focus changes
      }
    }
  }
}
