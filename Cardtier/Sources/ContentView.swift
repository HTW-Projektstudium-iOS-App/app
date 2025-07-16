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

  @State private var dragOffset: CGFloat = 0
  @State private var isStackExpanded: Bool = false
  @State private var stackScrollOffset: CGFloat = 0

  var body: some View {
    GeometryReader { geometry in
      NavigationStack {
        ZStack(alignment: .top) {
          Image(asset: CardtierImages(name: "Background Gradient"))
            .resizable()
            .ignoresSafeArea()

          ZStack(alignment: .top) {
            // TODO: add proper onboarding screen
            if editingCard || userCard == nil {
              EditView(card: userCard, cardNamespace: namespace) {
                withAnimation {
                  editingCard = false
                }
              }
            } else if let userCard {
              CardView(
                card: userCard,
                focusedCardID: .constant(nil),
                isFlipped: false,
                isScrolling: false,
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
              .opacity(isStackExpanded ? 0 : 1)
              .scaleEffect(isStackExpanded ? 0.95 : 1)
              .animation(.easeInOut(duration: 0.3), value: isStackExpanded)
              .zIndex(100)

              VStack(spacing: 0) {
                CardStack(cardOffset: !isStackExpanded ? -150 : 20) {
                  stackScrollOffset = $0
                }
                .scrollDisabled(!isStackExpanded)
                .allowsHitTesting(isStackExpanded)
                .simultaneousGesture(
                  DragGesture()
                    .onEnded { value in
                      if isStackExpanded && value.translation.height > 100 && stackScrollOffset > 0
                      {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                          isStackExpanded = false
                        }
                      }
                    }
                )
              }
              .padding(.top, geometry.safeAreaInsets.top)
              .ignoresSafeArea()
              .background(Color.clear.contentShape(Rectangle()))
              .offset(
                y: isStackExpanded
                  ? 0 : geometry.size.height * 0.5 + dragOffset + -stackScrollOffset
              )
              .gesture(
                DragGesture()
                  .onChanged { value in
                    if !isStackExpanded {
                      dragOffset = min(0, value.translation.height) * 0.3
                    }
                  }
                  .onEnded { value in
                    if !isStackExpanded {
                      let shouldExpand = shouldExpandStack(
                        translation: value.translation.height,
                        velocity: value.predictedEndTranslation.height
                      )

                      withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isStackExpanded = shouldExpand
                        dragOffset = 0
                      }
                    }
                  }
              )
              // .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isStackExpanded)
              .transition(.move(edge: .bottom))
            }
          }
        }
      }
    }
  }

  private func shouldExpandStack(translation: CGFloat, velocity: CGFloat) -> Bool {
    if velocity < -800 {
      return true
    } else if velocity > 800 {
      return false
    }
    return translation < -50
  }
}

#Preview {
  var sampleCard = Card.sampleCards[0]
  sampleCard.isUserCard = true

  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  // swiftlint:disable:next force_try
  let container = try! ModelContainer(for: Card.self, configurations: config)
  container.mainContext.insert(sampleCard)

  return ContentView()
    .modelContainer(container)
}
