import SwiftData
import SwiftUI

struct ContentView: View {
  @Namespace private var namespace

  @EnvironmentObject var cardExchange: CardExchangeService
  @Environment(\.modelContext) private var modelContext

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

  var isInProximity: Bool { cardExchange.closestPeer?.distance ?? 1 < 0.06 }
  @State private var isTransmitting = false
  @State private var showTransmissionControls = false
  @GestureState private var cardTransmissionDragOffset: CGSize = .zero
  @State private var cardTransmissionOffset: CGSize = .zero

  private func receiveCard(card: Card) {
    print("Received card: \(card.id)")

    guard !collectedCards.contains(where: { $0.id == card.id }) else { return }
    modelContext.insert(card)
  }

  var body: some View {
    GeometryReader { geometry in
      NavigationStack {
        ZStack(alignment: .top) {
          Image(asset: CardtierImages(name: "Background Gradient"))
            .resizable()
            .ignoresSafeArea()
            .onTapGesture {
              withAnimation(.spring(response: 0.8, dampingFraction: 0.5)) {
                isTransmitting = true
              } completion: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                  showTransmissionControls = true
                }
              }
            }

          ZStack(alignment: isTransmitting ? .bottom : .top) {
            // TODO: add proper onboarding screen
            if editingCard || userCard == nil {
              EditView(card: userCard, cardNamespace: namespace) {
                withAnimation {
                  editingCard = false
                }
              }
            } else if let userCard {
              if isTransmitting {
                Color.clear
                  .background(Material.ultraThin.opacity(0.3))
                  .ignoresSafeArea()
                  .zIndex(1)
                  .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                      showTransmissionControls = false
                    } completion: {
                      withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                        isTransmitting = false
                      }
                    }
                  }
              }

              VStack {
                Image(systemName: "chevron.up.2")
                  .font(.system(size: 50))
                  .foregroundStyle(.secondary)
                  .zIndex(75)
                  .offset(y: showTransmissionControls ? -30 : 40)
                  .opacity(showTransmissionControls ? 1 : 0)
                  .frame(height: 0)
                  .offset(
                    y: isTransmitting
                      ? cardTransmissionDragOffset.height + cardTransmissionOffset.height : 0
                  )

                CardView(
                  card: userCard,
                  focusedCardID: .constant(nil),
                  isFlipped: false,
                  isScrolling: false,
                  scrollVelocity: 0
                )
                // FIXME: this is broken when creating a new card
                .matchedGeometryEffect(id: userCard.id, in: namespace)
                .card(index: 0, zIndex: 100)
                .onTapGesture {
                  if !isTransmitting {
                    withAnimation {
                      editingCard.toggle()
                    }
                  }
                }
                .padding(.horizontal)
                .opacity(isStackExpanded ? 0 : 1)
                .scaleEffect(isStackExpanded ? 0.95 : isTransmitting ? 0.95 : 1)
                .animation(.easeInOut(duration: 0.3), value: isStackExpanded)
                .gesture(
                  DragGesture(coordinateSpace: .global)
                    .updating($cardTransmissionDragOffset) { value, state, _ in
                      state = value.translation
                    }
                    .onEnded { value in
                      cardTransmissionOffset = value.translation

                      let velocity = value.predictedEndTranslation.height - value.translation.height
                      let isSwipeUp = value.translation.height < -50
                      let isFastEnough = velocity < -500

                      if isSwipeUp && isFastEnough {
                        // fly off the screen
                        withAnimation(.easeOut(duration: 0.4)) {
                          cardTransmissionOffset.height = -geometry.size.height - 200
                        } completion: {
                          withAnimation {
                            cardTransmissionOffset = .zero
                            isTransmitting = false
                            showTransmissionControls = false
                          }
                        }

                        if let peer = cardExchange.closestPeer?.peer {
                          cardExchange.sendCard(userCard, to: peer)
                        }
                      } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                          cardTransmissionOffset = .zero
                        }
                      }
                    }
                )
                .offset(
                  y: isTransmitting
                    ? cardTransmissionDragOffset.height + cardTransmissionOffset.height : 0
                )
                .onChange(debounced: .seconds(2), of: isInProximity) { _, newValue in
                  if newValue {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5)) {
                      isTransmitting = true
                    } completion: {
                      withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                        showTransmissionControls = true
                      }
                    }
                  }
                }

                Text("Swipe up to send card")
                  .foregroundStyle(.secondary)
                  .padding(.top, 20)
                  .zIndex(75)
                  .offset(y: showTransmissionControls ? 0 : 40)
                  .opacity(showTransmissionControls ? 1 : 0)
              }
              .zIndex(100)

              if !isTransmitting {
                VStack(spacing: 0) {
                  Text(
                    "\(cardExchange.closestPeer?.peer.displayName ?? "No peer") - \(cardExchange.closestPeer?.distance ?? 0)"
                  )

                  CardStack(cards: collectedCards, cardOffset: !isStackExpanded ? -150 : 20) {
                    stackScrollOffset = $0
                  }
                  .scrollDisabled(!isStackExpanded)
                  .allowsHitTesting(isStackExpanded)
                  .simultaneousGesture(
                    DragGesture()
                      .onEnded { value in
                        if isStackExpanded && value.translation.height > 100
                          && stackScrollOffset > 0
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
                .blur(radius: isTransmitting ? 3 : 0)
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
                .transition(.move(edge: .bottom))
              }
            }
          }
        }
      }
    }
    .onAppear {
      cardExchange.onCardReceived = receiveCard
    }
    .onDisappear {
      cardExchange.onCardReceived = nil
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
