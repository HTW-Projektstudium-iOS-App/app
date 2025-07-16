import SwiftUI

struct EditView: View {
  @Environment(\.modelContext) private var modelContext

  var scrollDrag: some Gesture {
    DragGesture(minimumDistance: 10, coordinateSpace: .named("scroll"))
      .onChanged { value in
        if !isDragging {
          isDragging = true
          dragStartCardFrame = cardFrame
          dragStartFormOffset = formOffset

          let startLoc = value.startLocation
          isCardDragged = cardFrame?.contains(startLoc) ?? false
        }
      }
      .onEnded { value in
        if isCardDragged, value.translation.height > 100 {
          isDismissed = true
          lastDistance = formOffset ?? 0.0 - (dragStartFormOffset ?? 0.0)
          onDismiss()
        }

        if cardModel == nil {
          modelContext.insert(cardData.createCard())
        } else {
          cardData.apply(to: cardModel!)
        }

        isDragging = false
      }
  }

  // FIXME: somehow reset state if the user cancels the dismissal transition,
  // otherwise everything will be offset/hidden due to the half-done animation states

  @State private var cardFrame: CGRect?
  @State private var dragStartCardFrame: CGRect?

  @State private var formOffset: CGFloat?
  @State private var dragStartFormOffset: CGFloat?

  @State private var isDragging = false
  @State private var isCardDragged = false

  @State private var listHeight: CGFloat = 10

  @State private var activeCardIndex: Int? = 0

  @State private var isDismissed = false
  @State private var lastDistance = 0.0

  private var currentDistance: Double {
    Double(cardFrame?.minY ?? 0.0) - Double(dragStartCardFrame?.minY ?? 0.0)
  }

  private var cardModel: Card?
  @State private var cardData: CardDraft

  let cardNamespace: Namespace.ID
  let onDismiss: () -> Void

  init(card: Card?, cardNamespace: Namespace.ID, onDismiss: @escaping () -> Void) {
    self.cardModel = card
    self.cardNamespace = cardNamespace
    self.onDismiss = onDismiss

    if let card = cardModel {
      cardData = CardDraft(from: card)
    } else {
      cardData = CardDraft(from: Card.sampleUserCard)
    }
  }

  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            CardView(
              card: cardData.createCard(), focusedCardID: .constant(nil), isFlipped: false,
              isScrolling: false,
              scrollVelocity: 0
            )
            .matchedGeometryEffect(id: cardData.id, in: cardNamespace)
            .card(index: 0, zIndex: 0)
            .frame(width: geometry.size.width - 40)
            .onGeometryChange(
              for: CGRect.self,
              of: { proxy in
                proxy.frame(in: .named("scroll"))
              },
              action: { newFrame in
                if activeCardIndex == 0 {
                  cardFrame = newFrame
                }
              }
            )
            .id(0)

            CardView(
              card: cardData.createCard(), focusedCardID: .constant(nil), isFlipped: true,
              isScrolling: false,
              scrollVelocity: 0
            )
            .card(index: 0, zIndex: 0)
            .frame(width: geometry.size.width - 40)
            .onGeometryChange(
              for: CGRect.self,
              of: { proxy in
                proxy.frame(in: .named("scroll"))
              },
              action: { newFrame in
                if activeCardIndex == 1 {
                  cardFrame = newFrame
                }
              }
            )
            .id(1)
          }
          .scrollTargetLayout()
          .padding(.horizontal, 20)
          .padding(.bottom, 20)
          .padding(.top, 10)
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $activeCardIndex)
        .visualEffect { content, proxy in
          let offset = proxy.frame(in: .named("scroll")).minY

          return content.offset(
            y: !isCardDragged && offset > 0 ? -offset : 0
          )
        }

        Form {
          if activeCardIndex == 0 {
            CardEditor(for: .front, card: cardData)
          } else {
            CardEditor(for: .back, card: cardData)
          }
        }
        .animation(.easeInOut, value: activeCardIndex)
        .onScrollGeometryChange(for: CGFloat.self, of: \.contentSize.height) {
          if $1 > 0 {
            listHeight = $1
          }
        }
        .scrollDisabled(true)
        .frame(height: listHeight)
        .blur(
          radius: isCardDragged ? currentDistance / 50.0 : isDismissed ? lastDistance / 50.0 : 0
        )
        .opacity(
          isCardDragged ? 1 - currentDistance / 200.0 : isDismissed ? 0.3 : 1.0
        )
        .offset(y: isDismissed ? lastDistance - (formOffset ?? 0.0) : 0.0)
        .onGeometryChange(
          for: CGFloat.self,
          of: { proxy in
            proxy.frame(in: .named("scroll")).minY
          },
          action: { value in
            formOffset = value
          }
        )
        .opacity(isDismissed ? 0 : 1)
      }
      .coordinateSpace(.named("scroll"))
      .simultaneousGesture(scrollDrag)
      .background(Color(.systemGroupedBackground))
    }
  }
}

struct SliderField: View {
  let title: String
  @Binding var value: Double
  let range: ClosedRange<Double>

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(title)
        Spacer()
        Text("\(Int(value))")
          .foregroundColor(.secondary)
      }
      Slider(value: $value, in: range)
    }
  }
}

#Preview {
  @Previewable @Namespace var namespace

  EditView(
    card: Card.sampleCards[0], cardNamespace: namespace,
    onDismiss: {
      // do nothing
    })
}
