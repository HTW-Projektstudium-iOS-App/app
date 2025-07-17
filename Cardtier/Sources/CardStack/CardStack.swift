import SwiftUI

struct CardStack: View {
  @Namespace private var namespace

  var cards: [Card]
  @State private var focusedCardID: UUID?
  private var focusedCard: Card? { cards.first(where: { $0.id == focusedCardID }) }

  @State private var isFocusedCardFlipped = false
  @State private var isShowingInfo: Bool = false

  @State private var scrollReader: ScrollViewProxy?
  @State private var scrollVelocity: CGFloat = 0
  @State private var scrollEndTimer: Timer?
  @State private var lastScrollY: CGFloat = 0
  @State private var lastScrollTime = Date()
  @State private var isDragging: Bool = false
  @State private var isScrolling: Bool = false

  let cardOffset: CGFloat

  let onScrollOffsetChange: (CGFloat) -> Void

  var body: some View {
    ZStack(alignment: .top) {
      ScrollViewReader { proxy in
        ScrollView(.vertical) {
          ZStack(alignment: .top) {
            // Transparent overlay that captures taps to reset focus
            // When tapped outside cards, deselects the currently focused card
            Color.clear
              .contentShape(Rectangle())
              .zIndex(focusedCardID != nil ? 1000 : -1)
              .onTapGesture {
                if focusedCardID != nil {
                  withAnimation(.cardStack) {
                    focusedCardID = nil
                  } completion: {
                    isFocusedCardFlipped = false
                  }
                }
              }

            VStack(spacing: cardOffset > 0 ? cardOffset : 0) {
              ForEach(Array(cards.filter { $0.id != focusedCardID }.enumerated()), id: \.element.id)
              { index, card in
                CardView(
                  card: card,
                  focusedCardID: $focusedCardID,
                  isFlipped: false,
                  isScrolling: isScrolling,
                  scrollVelocity: scrollVelocity
                )
                .card(index: index, zIndex: cards.count - index)
                .padding(.horizontal)
                .matchedGeometryEffect(id: card.id, in: namespace)
                .zIndex(card.id == focusedCardID ? 2000 : -1)
                .offset(y: cardOffset < 0 ? cardOffset * CGFloat(index) : 0)
                .onTapGesture {
                  withAnimation {
                    focusedCardID = card.id
                  }
                }
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .identity))
              }
              .animation(.default, value: cards)
            }
            .padding(.bottom, 50)
            .animation(.cardStack, value: focusedCardID)
          }
          .onGeometryChange(
            for: CGFloat.self,
            of: { proxy in
              proxy.frame(in: .scrollView).minY
            }
          ) {
            onScrollOffsetChange($1)
          }
        }
        .onAppear {
          scrollReader = proxy
        }
        .simultaneousGesture(scrollGesture)
      }

      if let focusedCard {
        VStack(spacing: 32) {
          Spacer()

          CardView(
            card: focusedCard,
            focusedCardID: $focusedCardID,
            isFlipped: isFocusedCardFlipped,
            isScrolling: isScrolling,
            scrollVelocity: scrollVelocity
          )
          .focusedCard()
          .matchedGeometryEffect(id: focusedCard.id, in: namespace)
          .onTapGesture {
            withAnimation(.cardFlip) {
              isFocusedCardFlipped.toggle()
            }
          }
          .animation(.cardStack, value: focusedCardID)

          Button(action: {
            withAnimation {
              isShowingInfo = true
            }
          }) {
            Text("\(Image(systemName: "info.circle")) More Information")
              .padding(.horizontal)
              .padding(.vertical)
          }
          .apply {
            if #available(iOS 26.0, *) {
              $0.buttonStyle(.glass)
            } else {
              $0.buttonStyle(.bordered)
                .foregroundStyle(.black)
            }
          }

          Spacer()
        }
        .padding()
        .sheet(isPresented: $isShowingInfo) {
          CardInfoSheet(card: focusedCard, isPresented: $isShowingInfo)
        }
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
      } completion: {
        isFocusedCardFlipped = false
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
  CardStack(cards: Card.sampleCards, cardOffset: 0) { _ in
    // do nothing
  }
}
