import SwiftUI

struct ContentView: View {
  @Namespace private var namespace

  @State private var card = Card.sampleCards[0]
  @State private var editingCard = false

  @State private var scrollOffset: CGFloat = 0

  var body: some View {
    VStack {
      if editingCard {
        EditView(card: card, cardNamespace: namespace) {
          withAnimation {
            editingCard = false
          }
        }
      } else {
        CardView(
          card: card, focusedCardID: .constant(nil), isFlipped: false, isScrolling: false,
          scrollVelocity: 0
        )
        .matchedGeometryEffect(id: card.id, in: namespace, isSource: true)
        .card(index: 0, zIndex: 0)
        .onTapGesture {
          withAnimation {
            editingCard.toggle()
          }
        }
        .padding(.horizontal)

        Spacer()

        ZStack {
          CardView(
            card: Card.sampleCards[1], focusedCardID: .constant(nil), isFlipped: false,
            isScrolling: false,
            scrollVelocity: 0
          )
          .card(index: 0, zIndex: 3)
          .offset(y: 50)

          CardView(
            card: Card.sampleCards[1], focusedCardID: .constant(nil), isFlipped: false,
            isScrolling: false,
            scrollVelocity: 0
          )
          .card(index: 0, zIndex: 2)

          CardView(
            card: Card.sampleCards[1], focusedCardID: .constant(nil), isFlipped: false,
            isScrolling: false,
            scrollVelocity: 0
          )
          .card(index: 0, zIndex: 1)
          .offset(y: -50)
        }
        .transition(.move(edge: .bottom).animation(.easeInOut(duration: 5.25)))
        .padding(.horizontal)
        //        .offset(y: 200)
      }
    }
  }
}

#Preview {
  ContentView()
}
