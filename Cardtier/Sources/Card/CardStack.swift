import SwiftUI

struct CardStack: View {
  @State private var cards: [Card] = Card.sampleCards
  @State private var focusedCardID: UUID?
  private var focusedCard: Card? { cards.first(where: { $0.id == focusedCardID }) }

  @State private var scrollPosition: CGPoint = .zero
  @State private var scrollReader: ScrollViewProxy?

  @State private var isDragging: Bool = false

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
                  withAnimation(.cardFocus) {
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
                    focusedCardID: $focusedCardID
                  )
                  .card(index: index)
                }
              }
            }
            .padding(.top, CardConstants.Layout.stackTopPadding)
            .animation(.cardStack, value: focusedCardID)
          }
        }
        .onAppear {
          scrollReader = proxy
        }
        .simultaneousGesture(
          DragGesture(minimumDistance: CardConstants.Layout.dragMinDistance, coordinateSpace: .local)
            .onChanged { _ in
              if !isDragging && focusedCardID != nil {
                isDragging = true
                withAnimation(.cardFocus) {
                  focusedCardID = nil
                }
              }
            }
            .onEnded { _ in
              isDragging = false
            }
        )
      }

      if let focusedCard {
        CardView(
          card: focusedCard,
          focusedCardID: $focusedCardID
        )
        .focusedCard()
        .animation(.cardStack, value: focusedCardID)
      }
    }
    .background(Color(UIColor.systemGroupedBackground))
    .onChange(of: focusedCardID) { _, newValue in
      if newValue != nil {
        withAnimation(.cardStack) {
          scrollReader?.scrollTo("stackAnchor", anchor: .top)
        }
      }
    }
  }
}

#Preview {
  CardStack()
}
