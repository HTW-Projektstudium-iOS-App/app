import SwiftUI

struct CardFrameKey: PreferenceKey {
  static var defaultValue: CGRect = CGRect.null
  static func reduce(
    value: inout CGRect,
    nextValue: () -> CGRect
  ) {
    value = nextValue()
  }
}

public struct EditView: View {
  @Environment(\.modelContext) private var modelContext

  var scrollDrag: some Gesture {
    DragGesture(minimumDistance: 0, coordinateSpace: .named("scroll"))
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

          if isNew {
            modelContext.insert(card)
          }
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

  @State private var card: Card
  private let isNew: Bool
  let cardNamespace: Namespace.ID
  let onDismiss: () -> Void

  init(card: Card?, cardNamespace: Namespace.ID, onDismiss: @escaping () -> Void) {
    _card = .init(initialValue: card ?? Card.sampleCards[0])
    self.cardNamespace = cardNamespace
    self.onDismiss = onDismiss

    self.isNew = card == nil
  }

  public var body: some View {
    GeometryReader { geometry in
      ScrollView {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            CardView(
              card: card, focusedCardID: .constant(nil), isFlipped: false, isScrolling: false,
              scrollVelocity: 0
            )
            .matchedGeometryEffect(id: card.id, in: cardNamespace)
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
              card: card, focusedCardID: .constant(nil), isFlipped: true, isScrolling: false,
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

        //        Text("\(currentScrollOffset), \(activeCardIndex)")

        Form {
          if activeCardIndex == 0 {
            Section(header: Text("Personal Information")) {
              TextField("Name", text: .constant(card.name))
              TextField("Title", text: .constant(card.title ?? ""))
              TextField("Company", text: .constant(card.company ?? ""))
            }
            .transition(.asymmetric(insertion: .opacity, removal: .opacity))

            Section(header: Text("Styling")) {
              ColorPicker("Background Color", selection: .constant(card.style.primaryColor))
              ColorPicker(
                "Text Color", selection: .constant(card.style.secondaryColor ?? .black))
              SliderField(
                title: "Font Size",
                value: .constant(15),
                range: 12...24
              )
            }
          } else {
            Section(header: Text("Contact Information")) {
              TextField("Email", text: .constant(card.contactInformation.email ?? ""))
              TextField("Phone", text: .constant(card.contactInformation.phoneNumber ?? ""))
              TextField(
                "Website", text: .constant(card.contactInformation.websiteURL?.path() ?? ""))
            }

            Section(header: Text("Styling")) {
              ColorPicker("Background Color", selection: .constant(card.style.primaryColor))
              ColorPicker(
                "Text Color", selection: .constant(card.style.secondaryColor ?? .black))
              SliderField(
                title: "Font Size",
                value: .constant(15),
                range: 10...20
              )
            }
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
        // .animation(.easeInOut, value: isDismissed)
      }
      .coordinateSpace(.named("scroll"))
      //      .onPreferenceChange(CardFrameKey.self) { cardFrame = $0; print("onPrefChange: \($0)") }
      .simultaneousGesture(scrollDrag)
      .background(Color(.systemGroupedBackground))
    }
    //    .transition(.slide)
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
