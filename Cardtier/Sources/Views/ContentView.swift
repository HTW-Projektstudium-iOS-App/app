// Sources/Cardtier/Views/ContentView.swift
import SwiftUI

/// Main view displaying a stack of business cards
public struct ContentView: View {
    /// View model managing the card stack data and state
    @StateObject private var viewModel = CardStackViewModel(withSampleData: true)
    
    /// Creates the main content view
    public init() {}
    
    public var body: some View {
        ZStack(alignment: .top) {
            cardStackView
            focusedCardView
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    /// The scrollable stack of cards
    private var cardStackView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .top) {
                // Transparent overlay for tap-to-reset (only on empty stack area)
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.focusedCardID != nil {
                            viewModel.resetFocusedCard()
                        }
                    }
                
                VStack(spacing: 0) {
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
                            .zIndex(Double(index))
                            .offset(y: CGFloat(index) * CardDesign.Layout.cardStackOffset)
                        }
                    }
                }
                .padding(.top, CardDesign.Layout.stackTopPadding)
            }
        }
        // Detect scrolling with gesture
        .simultaneousGesture(
            DragGesture(minimumDistance: CardDesign.Layout.dragMinDistance, coordinateSpace: .local)
                .onChanged { _ in
                    if !viewModel.isDragging && viewModel.focusedCardID != nil {
                        viewModel.isDragging = true
                        viewModel.resetFocusedCard()
                    }
                }
                .onEnded { _ in
                    viewModel.isDragging = false
                }
        )
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
                .transition(.identity)
                .animation(CardDesign.Animation.focusTransition, value: viewModel.focusedCardID)
            }
        }
    }
}

/// Preview provider for the content view
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
