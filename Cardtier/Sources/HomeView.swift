import SwiftUI

struct HomeView: View {
  @State private var dragOffset: CGFloat = 0
  @State private var isDragging: Bool = false
  @State private var isStackExpanded: Bool = false
  @State private var focusedCardID: UUID?
  @State private var lastScrollOffset: CGFloat = 0
  @State private var scrollVelocity: CGFloat = 0
  @State private var lastScrollTime: Date = Date()
  private let userCard = Card.sampleCards[1]

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .top) {
        // Background
        Color(UIColor.systemGroupedBackground)
          .ignoresSafeArea()

        // Top section with user card
        VStack(spacing: 20) {
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              Text("Meine Karte")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            }
            Spacer()
          }
          .padding(.horizontal, 20)
          .padding(.top, 20)

          CardView(
            card: userCard,
            focusedCardID: $focusedCardID,
            isScrolling: false,
            scrollVelocity: 0
          )
          .frame(height: 240)
          .scaleEffect(0.8)

          Spacer()
        }
        .padding(.bottom, geometry.size.height * 0.4)
        .scaleEffect(isStackExpanded ? 0.95 : 1)
        .animation(.easeInOut(duration: 0.3), value: isStackExpanded)

        // CardStack section
        VStack(spacing: 0) {
          // CardStack content
          CardStack()
            .scrollDisabled(!isStackExpanded)
            .allowsHitTesting(isStackExpanded)
            .simultaneousGesture(
              DragGesture()
                .onChanged { value in
                  // Only handle when expanded and scrolling down from top
                  if isStackExpanded && value.translation.height > 0 {
                    dragOffset = value.translation.height * 0.3
                  }
                }
                .onEnded { value in
                  if isStackExpanded && value.translation.height > 230 {
                    // Collapse the stack
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                      isStackExpanded = false
                      dragOffset = 0
                    }
                  } else {
                    // Reset drag offset
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                      dragOffset = 0
                    }
                  }
                }
            )
        }
        .frame(height: geometry.size.height)
        .background(Color.clear.contentShape(Rectangle()))
        .clipShape(RoundedRectangle(cornerRadius: isStackExpanded ? 20 : 0))
        .offset(y: isStackExpanded ? 0 : geometry.size.height * 0.5) //  wo CardStack beginnt
        .offset(y: dragOffset)
        .gesture(
          DragGesture()
            .onChanged { value in
              if !isDragging {
                isDragging = true
              }
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
                  isDragging = false
                }
              }
            }
        )
        .zIndex(10)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isStackExpanded)
      }
    }
    .onAppear {
      focusedCardID = userCard.id
    }
  }

  // MARK: - Helper
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
  HomeView()
}
