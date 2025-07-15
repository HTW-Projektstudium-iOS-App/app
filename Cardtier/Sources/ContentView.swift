import SwiftData
import SwiftUI

struct ContentView: View {
  @Namespace private var namespace

  @Query(filter: #Predicate<Card> { $0.isUserCard == true })
  private var _userCard: [Card]
  private var userCard: Card? {
    _userCard.first
  }

  @Query(filter: #Predicate<Card> { $0.isUserCard == false })
  private var collectedCards: [Card]

  @State private var editingCard = false

  var body: some View {
    NavigationStack {
      ZStack {
        Image(asset: CardtierImages(name: "Background Gradient"))
          .resizable()
          .ignoresSafeArea()

        VStack {
          // TODO: add proper onboarding screen
          if editingCard || userCard == nil {
            EditView(card: userCard, cardNamespace: namespace) {
              withAnimation {
                editingCard = false
              }
            }
          } else if let userCard {
            CardView(
              card: userCard, focusedCardID: .constant(nil), isFlipped: false, isScrolling: false,
              scrollVelocity: 0
            )
            // FIXME: this is broken when creating a new card
            .matchedGeometryEffect(id: userCard.id, in: namespace)
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
                card: Card.sampleCards[0], focusedCardID: .constant(nil), isFlipped: false,
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
                card: Card.sampleCards[2], focusedCardID: .constant(nil), isFlipped: false,
                isScrolling: false,
                scrollVelocity: 0
              )
              .card(index: 0, zIndex: 1)
              .offset(y: -50)
            }
            .transition(.move(edge: .bottom).animation(.easeInOut(duration: 5.25)))
            .padding(.horizontal)
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
