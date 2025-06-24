import SwiftUI

/// Main view displaying a stack of business cards
/// This is the primary container view that manages card layout and interactions
public struct ContentView: View {
    /// View model managing the card stack data and state
    /// Contains all business cards and tracks their individual states
    @StateObject private var viewModel = CardStackViewModel(withSampleData: true)
    
    /// Reference to the ScrollViewProxy for programmatic scrolling
    @State private var scrollReader: ScrollViewProxy? = nil
    
    /// Animation for card stack movement
    private let stackAnimation = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)
    
    /// Timer to debounce scroll end detection
    @State private var scrollEndTimer: Timer? = nil
    
    /// Last recorded scroll position in Y direction
    @State private var lastScrollY: CGFloat = 0
    
    /// Timestamp of the last scroll position measurement
    @State private var lastScrollTime = Date()
    
    /// Creates the main content view
    public init() {}
    
    public var body: some View {
        // Main container with stacked layout
        ZStack(alignment: .top) {
            // Background stack of cards (scrollable)
            cardStackView
            
            // Currently focused card (if any)
            focusedCardView
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onChange(of: viewModel.focusedCardID) { oldValue, newValue in
            if newValue != nil {
                withAnimation(stackAnimation) {
                    scrollReader?.scrollTo("stackAnchor", anchor: .top)
                }
            }
        }
        .environmentObject(viewModel)
    }
    
    /// The scrollable stack of cards
    private var cardStackView: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    // Transparent overlay that captures taps to reset focus
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
                        // Invisible spacer
                        Color.clear
                            .frame(height: viewModel.focusedCardID != nil ? 250 : 0)
                            .id("stackAnchor") // ID for programmatic scrolling
                        
                        // Loop through all cards
                        ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                            if card.id != viewModel.focusedCardID {
                                CardView(
                                    card: card,
                                    isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
                                    showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
                                    focusedCardID: $viewModel.focusedCardID
                                )
                                .frame(height: CardDesign.Layout.cardHeight)
                                .padding(.horizontal, CardDesign.Layout.horizontalPadding)
                                .zIndex(Double(viewModel.cards.count - index))
                                .offset(y: CGFloat(index) * CardDesign.Layout.cardStackOffset)
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
                    .animation(stackAnimation, value: viewModel.focusedCardID)
                }
            }
            .onAppear {
                scrollReader = proxy
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: CardDesign.Layout.dragMinDistance, coordinateSpace: .local)
                    .onChanged { value in
                        // Calculate time elapsed since last measurement
                        let now = Date()
                        let timeElapsed = now.timeIntervalSince(lastScrollTime)
                        
                        // Calculate true velocity (distance/time)
                        if timeElapsed > 0 {
                            let currentY = value.translation.height
                            let deltaY = currentY - lastScrollY
                            let velocity = deltaY / CGFloat(timeElapsed)
                            
                            // Apply smoothing and clamping
                            viewModel.scrollVelocity = (viewModel.scrollVelocity * 0.7) + (abs(velocity) * 0.0015).clamped(to: 0.0...3.0)
                        }
                        
                        // Update tracking variables
                        lastScrollY = value.translation.height
                        lastScrollTime = now
                        
                        // Reset focus if needed
                        if !viewModel.isDragging && viewModel.focusedCardID != nil {
                            viewModel.isDragging = true
                            withAnimation(stackAnimation) {
                                viewModel.resetFocusedCard()
                            }
                        }
                        
                        // Update scrolling state
                        viewModel.isScrolling = true
                        viewModel.lastScrollTime = now
                        
                        // Reset scroll end detection
                        scrollEndTimer?.invalidate()
                        scrollEndTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                            if Date().timeIntervalSince(viewModel.lastScrollTime) >= 0.2 {
                                withAnimation(CardDesign.Animation.scrollEndTransition) {
                                    viewModel.isScrolling = false
                                }
                                
                                // Smoothly decay velocity to zero
                                withAnimation(.easeOut(duration: 0.6)) {
                                    viewModel.scrollVelocity = 0
                                }
                            }
                        }
                    }
                    .onEnded { _ in
                        viewModel.isDragging = false
                        lastScrollY = 0
                        
                        // Handle scroll end with physics-based decay
                        scrollEndTimer?.invalidate()
                        scrollEndTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { _ in
                            withAnimation(CardDesign.Animation.scrollEndTransition) {
                                viewModel.isScrolling = false
                            }
                            
                            // Gradual velocity decay for natural feel
                            withAnimation(.easeOut(duration: 0.6)) {
                                viewModel.scrollVelocity = 0
                            }
                        }
                    }
            )
        }
    }
    
    /// The currently focused card, if any
    private var focusedCardView: some View {
        Group {
            if let card = viewModel.focusedCard {
                CardView(
                    card: card,
                    isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
                    showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
                    focusedCardID: $viewModel.focusedCardID
                )
                .frame(height: CardDesign.Layout.cardHeight)
                .padding(.horizontal, CardDesign.Layout.horizontalPadding)
                .zIndex(1000)
                .padding(.top, CardDesign.Layout.focusedCardTopPadding)
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
                .shadow(radius: 10, x: 0, y: 3)
                .rotation3DEffect(
                    .degrees(1),
                    axis: (x: 1.0, y: 0, z: 0),
                    anchor: .center,
                    perspective: 0.1
                )
                .animation(stackAnimation, value: viewModel.focusedCardID)
            }
        }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
