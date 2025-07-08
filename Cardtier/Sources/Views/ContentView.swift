import SwiftUI

public struct ContentView: View {
  @StateObject private var viewModel = CardStackViewModel(withSampleData: true)

  @State private var scrollPosition: CGPoint = .zero
  @State private var scrollReader: ScrollViewProxy?

  private let stackAnimation = Animation.spring(
    response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)

  public init() {}

  public var body: some View {
    ZStack(alignment: .top) {
      cardStackView

      focusedCardView
    }
    .background(Color(UIColor.systemGroupedBackground))
    .onChange(of: viewModel.focusedCardID) { _, newValue in
      if newValue != nil {
        withAnimation(stackAnimation) {
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
                withAnimation(stackAnimation) {
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
                  isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
                  showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
                  focusedCardID: $viewModel.focusedCardID
                )
                .frame(height: CardDesign.Layout.cardHeight)
                .padding(.horizontal, CardDesign.Layout.horizontalPadding)
                .zIndex(Double(index))
                .offset(y: CGFloat(index) * CardDesign.Layout.cardStackOffset)
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
          .animation(stackAnimation, value: viewModel.focusedCardID)
        }
      }
      .onAppear {
        scrollReader = proxy
      }
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
