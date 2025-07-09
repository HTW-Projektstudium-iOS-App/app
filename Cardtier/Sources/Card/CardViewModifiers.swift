import SwiftUI

private struct BaseCardModifier: ViewModifier {
  let removalEdge: Edge

  func body(content: Content) -> some View {
    content
      .aspectRatio(1.6, contentMode: .fit)
      .padding(.horizontal, 20)
      .transition(
        .asymmetric(
          insertion: .opacity
            .combined(with: .move(edge: .bottom))
            .animation(.easeOut(duration: 0.4)),
          removal: .opacity
            .combined(with: .move(edge: removalEdge))
            .animation(.easeIn(duration: 0.35))
        )
      )

  }
}

struct FocusedCardModifier: ViewModifier {

  func body(content: Content) -> some View {
    content
      .baseCard(removalEdge: .bottom)
      .zIndex(1000)
      .padding(.top, 40)
      .shadow(radius: 10, x: 0, y: 3)
      .rotation3DEffect(
        .degrees(1),
        axis: (x: 1.0, y: 0, z: 0),
        anchor: .center,
        perspective: 0.1
      )
  }
}

struct CardModifier: ViewModifier {
  let index: Int
  let zIndex: Int

  func body(content: Content) -> some View {
    content
      .baseCard(removalEdge: .top)
      .zIndex(Double(zIndex))
      .offset(y: CGFloat(index) * -25)
  }
}

extension View {
  fileprivate func baseCard(removalEdge: Edge) -> some View {
    modifier(BaseCardModifier(removalEdge: removalEdge))
  }

  func focusedCard() -> some View {
    modifier(FocusedCardModifier())
  }

  func card(index: Int, zIndex: Int) -> some View {
    modifier(CardModifier(index: index, zIndex: zIndex))
  }
}
