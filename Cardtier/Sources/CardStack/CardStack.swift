import SwiftUI

struct CardStack: View {
  @State private var cards: [Card] = Card.sampleCards
  @State private var focusedCardID: UUID?
  private var focusedCard: Card? { cards.first(where: { $0.id == focusedCardID }) }

  @State private var isFocusedCardFlipped = false

  @State private var scrollReader: ScrollViewProxy?
  @State private var scrollVelocity: CGFloat = 0
  @State private var scrollEndTimer: Timer?
  @State private var lastScrollY: CGFloat = 0
  @State private var lastScrollTime = Date()
  @State private var isDragging: Bool = false
  @State private var isScrolling: Bool = false

  var body: some View {
    ZStack(alignment: .top) {
      ScrollViewReader { proxy in
        ScrollView(.vertical, showsIndicators: false) {
          ZStack(alignment: .top) {
            // Transparent overlay that captures taps to reset focus
            // When tapped outside cards, deselects the currently focused card
            Color.clear
              .contentShape(Rectangle())
              .onTapGesture {
                if focusedCardID != nil {
                  withAnimation(.cardStack) {
                    focusedCardID = nil
                  }
                }
              }

            VStack(spacing: 0) {
              // Invisible spacer that creates room at the top when a card is focused
              // Pushes the card stack down to make space for the focused card
              Color.clear
                .frame(height: focusedCardID != nil ? 250 : 0)
                .id("stackAnchor")

              ForEach(cards.enumerated(), id: \.element.id) { index, card in
                if card.id != focusedCardID {
                  CardView(
                    card: card,
                    focusedCardID: $focusedCardID,
                    isFlipped: false,
                    isScrolling: isScrolling,
                    scrollVelocity: scrollVelocity
                  )
                  .card(index: index, zIndex: cards.count - index)
                  .onTapGesture {
                    withAnimation {
                      focusedCardID = card.id
                    }
                  }
                }
              }
            }
            .padding(.top, 180)
            .padding(.bottom, 220)
            .animation(.cardStack, value: focusedCardID)
          }
        }
        .onAppear {
          scrollReader = proxy
        }
        .simultaneousGesture(scrollGesture)
      }

      if let focusedCard {
        CardView(
          card: focusedCard,
          focusedCardID: $focusedCardID,
          isFlipped: isFocusedCardFlipped,
          isScrolling: isScrolling,
          scrollVelocity: scrollVelocity
        )
        .focusedCard()
        .onTapGesture {
          withAnimation(.cardFlip) {
            isFocusedCardFlipped.toggle()
          }
        }
        .animation(.cardStack, value: focusedCardID)
      }
    }
    .onChange(of: focusedCardID) { _, newValue in
      if newValue != nil {
        withAnimation(.cardStack) {
          scrollReader?.scrollTo("stackAnchor", anchor: .top)
        }

        isFocusedCardFlipped = false
      }
    }
  }

  private var scrollGesture: some Gesture {
    DragGesture(minimumDistance: 1, coordinateSpace: .local)
      .onChanged(handleScrollChange)
      .onEnded(handleScrollEnd)
  }

  /// Handles continuous scroll gesture updates
  /// Calculates scroll velocity and manages card focus states
  private func handleScrollChange(_ value: DragGesture.Value) {
    let now = Date()
    let timeElapsed = now.timeIntervalSince(lastScrollTime)

    // Calculate scroll velocity for physics-based animations
    if timeElapsed > 0 {
      let currentY = value.translation.height
      let deltaY = currentY - lastScrollY
      let velocity = deltaY / CGFloat(timeElapsed)

      // Normalize and clamp velocity to prevent extreme values
      let normalizedVelocity = abs(velocity) * 0.0015
      let clampedVelocity = max(0.0, min(3, normalizedVelocity))

      // Apply smoothing to velocity for natural feeling animations
      scrollVelocity = (scrollVelocity * 0.7) + clampedVelocity
    }

    // Update tracking variables for next iteration
    lastScrollY = value.translation.height
    lastScrollTime = now
    isScrolling = true

    // Auto-dismiss focused card when user starts dragging
    if !isDragging && focusedCardID != nil {
      isDragging = true
      withAnimation(.cardStack) {
        focusedCardID = nil
      }
    }

    // Reset the timer that detects scroll end
    resetScrollEndTimer()
  }

  /// Handles the end of scroll gestures
  /// Resets dragging state and scroll end detection
  private func handleScrollEnd(_ value: DragGesture.Value) {
    isDragging = false
    lastScrollY = 0
    resetScrollEndTimer()
  }

  // MARK: - Scroll End Detection

  /// Manages a timer-based system to detect when scrolling has stopped
  /// This is necessary because SwiftUI doesn't provide native scroll end events
  private func resetScrollEndTimer() {
    // Cancel any existing timer
    scrollEndTimer?.invalidate()

    // Start a new timer to check if scrolling has stopped
    scrollEndTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
      // Check if enough time has passed since the last scroll event
      if Date().timeIntervalSince(lastScrollTime) >= 0.2 {
        // Mark scrolling as ended with smooth animation
        withAnimation(.easeOut(duration: 0.8)) {
          isScrolling = false
        }

        // Gradually reduce scroll velocity to zero
        withAnimation(.easeOut(duration: 0.6)) {
          scrollVelocity = 0
        }
      }
    }
  }
}

#Preview {
  CardStack()
}
