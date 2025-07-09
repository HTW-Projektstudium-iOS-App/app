import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = CardStackViewModel(withSampleData: true)

  @State private var scrollPosition: CGPoint = .zero
  @State private var scrollReader: ScrollViewProxy?

  @State private var isDragging: Bool = false

  init() {}

  var body: some View {
    ZStack(alignment: .top) {
      cardStackView

      focusedCardView
    }
    .background(Color(UIColor.systemGroupedBackground))
    .onChange(of: viewModel.focusedCardID) { _, newValue in
      if newValue != nil {
        withAnimation(.cardStack) {
          scrollReader?.scrollTo("stackAnchor", anchor: .top)
        }
      }
    }
  }

  private var cardStackView: some View {
    ScrollViewReader { proxy in
      ScrollView(.vertical, showsIndicators: false) {
        ZStack(alignment: .top) {
          // Transparent overlay that captures taps to reset focus
          // When tapped outside cards, deselects the currently focused card
          Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
              if viewModel.focusedCardID != nil {
                withAnimation(.cardStack) {
                  viewModel.resetFocusedCard()
                }
              }
            }

          VStack(spacing: 0) {
            // Invisible spacer that creates room at the top when a card is focused
            // Pushes the card stack down to make space for the focused card
            Color.clear
              .frame(height: viewModel.focusedCardID != nil ? 250 : 0)
              .id("stackAnchor")

            ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
              if card.id != viewModel.focusedCardID {
                CardView(
                  card: card,
                  focusedCardID: $viewModel.focusedCardID
                )
                .frame(height: CardConstants.Layout.cardHeight)
                .padding(.horizontal, CardConstants.Layout.horizontalPadding)
                .zIndex(Double(index))
                .offset(y: CGFloat(index) * CardConstants.Layout.cardStackOffset)
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
          .padding(.top, CardConstants.Layout.stackTopPadding)
          .animation(.cardStack, value: viewModel.focusedCardID)
        }
      }
      .onAppear {
        scrollReader = proxy
      }
      .simultaneousGesture(
        DragGesture(minimumDistance: CardConstants.Layout.dragMinDistance, coordinateSpace: .local)
          .onChanged { _ in
            if !isDragging && viewModel.focusedCardID != nil {
              isDragging = true
              withAnimation(.cardStack) {
                viewModel.resetFocusedCard()
              }
            }
          }
          .onEnded { _ in
            isDragging = false
          }
      )
    }
  }

  private var focusedCardView: some View {
    Group {
      if let card = viewModel.focusedCard {
        CardView(
          card: card,
          focusedCardID: $viewModel.focusedCardID
        )
        .frame(height: CardConstants.Layout.cardHeight)
        .padding(.horizontal, CardConstants.Layout.horizontalPadding)
        .zIndex(1000)
        .padding(.top, CardConstants.Layout.focusedCardTopPadding)
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
        .animation(.cardStack, value: viewModel.focusedCardID)
      }
    }
  }
}
