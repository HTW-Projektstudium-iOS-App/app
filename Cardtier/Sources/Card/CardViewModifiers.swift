import SwiftUI

private struct BaseCardModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .aspectRatio(1.6, contentMode: .fit)
  }
}

struct FocusedCardModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .baseCard()
      .zIndex(2000)
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
      .baseCard()
      .zIndex(Double(zIndex))
  }
}

struct CardAnimationModifier: ViewModifier {
  let removalEdge: Edge

  func body(content: Content) -> some View {
    content
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

extension View {
  fileprivate func baseCard() -> some View {
    modifier(BaseCardModifier())
  }

  func focusedCard() -> some View {
    modifier(FocusedCardModifier())
  }

  func card(index: Int, zIndex: Int) -> some View {
    modifier(CardModifier(index: index, zIndex: zIndex))
  }

  func cardAnimation(removalEdge: Edge) -> some View {
    modifier(CardAnimationModifier(removalEdge: removalEdge))
  }
}
