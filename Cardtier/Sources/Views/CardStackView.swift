import SwiftUI

/// A view that displays a stack of cards in a scrollable interface
/// Handles card stacking, scroll gestures, and focused card interactions
struct CardStackView: View {
    // MARK: - Dependencies
    @EnvironmentObject private var viewModel: CardStackViewModel
    @Binding var scrollReader: ScrollViewProxy?
    
    // MARK: - Animation Configuration
    /// Spring animation used for smooth card transitions and focus changes
    private let stackAnimation = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)
    
    // MARK: - State Management
    /// Timer to detect when scrolling has ended
    @State private var scrollEndTimer: Timer?
    /// Last recorded Y position during scroll gestures
    @State private var lastScrollY: CGFloat = 0
    /// Timestamp of the last scroll event for velocity calculation
    @State private var lastScrollTime = Date()
    
    // MARK: - Main View Body
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    // MARK: - Gesture Overlay
                    /// Invisible overlay that captures tap gestures across the entire scroll area
                    /// Used to dismiss focused cards when tapping outside
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // If a card is currently focused, reset it when tapping empty space
                            if viewModel.focusedCardID != nil {
                                withAnimation(stackAnimation) {
                                    viewModel.resetFocusedCard()
                                }
                            }
                        }
                    
                    // MARK: - Card Stack Container
                    VStack(spacing: 0) {
                        /// Invisible spacer that creates room at the top when a card is focused
                        /// This pushes the card stack down to make space for the focused card
                        Color.clear
                            .frame(height: viewModel.focusedCardID != nil ? CardStackViewConstants.focusedSpacerHeight : 0)
                            .id("stackAnchor") // Anchor point for scroll-to positioning
                        
                        // MARK: - Card Stack Rendering
                        /// Iterate through all cards with their index for proper z-ordering
                        ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                            // Only render cards that are not currently focused
                            // Focused cards are rendered separately in FocusedCardView
                            if card.id != viewModel.focusedCardID {
                                CardView(
                                    card: card,
                                    // Create two-way bindings for card state
                                    isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
                                    showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
                                    focusedCardID: $viewModel.focusedCardID
                                )
                                .frame(height: CardDesign.Layout.cardHeight)
                                .padding(.horizontal, CardDesign.Layout.horizontalPadding)
                                /// Higher z-index for cards earlier in the array (top of stack)
                                .zIndex(Double(viewModel.cards.count - index))
                                /// Create stacking effect by offsetting each card vertically
                                .offset(y: CGFloat(index) * CardDesign.Layout.cardStackOffset)
                                /// Smooth transitions when cards are added or removed
                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.combined(with: .move(edge: .bottom)).animation(.easeOut(duration: 0.4)),
                                        removal: .opacity.combined(with: .move(edge: .top)).animation(.easeIn(duration: 0.35))
                                    )
                                )
                            }
                        }
                    }
                    .padding(.top, CardDesign.Layout.stackTopPadding)
                    /// Animate the entire stack when focus changes
                    .animation(stackAnimation, value: viewModel.focusedCardID)
                    .padding(.bottom, CardStackViewConstants.stackBottomPadding)
                }
            }
            .onAppear {
                // Store the scroll proxy for external scroll control
                scrollReader = proxy
            }
            /// Attach scroll gesture handling without interfering with native scroll behavior
            .simultaneousGesture(scrollGesture)
        }
    }
    
    // MARK: - Gesture Handling
    
    /// Custom drag gesture for detecting scroll behavior and velocity
    private var scrollGesture: some Gesture {
        DragGesture(minimumDistance: CardDesign.Layout.dragMinDistance, coordinateSpace: .local)
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
            let normalizedVelocity = abs(velocity) * CardStackViewConstants.velocityNormalizationFactor
            let clampedVelocity = max(0.0, min(CardStackViewConstants.velocityClamp, normalizedVelocity))
            
            // Apply smoothing to velocity for natural feeling animations
            viewModel.scrollVelocity = (viewModel.scrollVelocity * 0.7) + clampedVelocity
        }
        
        // Update tracking variables for next iteration
        lastScrollY = value.translation.height
        lastScrollTime = now
        
        // Auto-dismiss focused card when user starts dragging
        if !viewModel.isDragging && viewModel.focusedCardID != nil {
            viewModel.isDragging = true
            withAnimation(stackAnimation) {
                viewModel.resetFocusedCard()
            }
        }
        
        // Update scroll state in view model
        viewModel.isScrolling = true
        viewModel.lastScrollTime = now
        
        // Reset the timer that detects scroll end
        resetScrollEndTimer()
    }
    
    /// Handles the end of scroll gestures
    /// Resets dragging state and scroll end detection
    private func handleScrollEnd(_ value: DragGesture.Value) {
        viewModel.isDragging = false
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
        scrollEndTimer = Timer.scheduledTimer(withTimeInterval: CardStackViewConstants.scrollEndTimerInterval, repeats: false) { _ in
            // Check if enough time has passed since the last scroll event
            if Date().timeIntervalSince(viewModel.lastScrollTime) >= CardStackViewConstants.scrollEndThreshold {
                // Mark scrolling as ended with smooth animation
                withAnimation(CardDesign.Animation.scrollEndTransition) {
                    viewModel.isScrolling = false
                }
                
                // Gradually reduce scroll velocity to zero
                withAnimation(.easeOut(duration: CardStackViewConstants.scrollVelocityWindDownDuration)) {
                    viewModel.scrollVelocity = 0
                }
            }
        }
    }
}
