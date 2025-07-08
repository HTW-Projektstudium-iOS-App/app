import SwiftUI

extension Animation {
  /// Standard animation for card focus/unfocus transitions
  static var cardFocus: Animation { .spring(response: 0.3, dampingFraction: 0.7) }

  /// Animation for card flip transitions
  static var cardFlip: Animation { .spring(response: 0.5, dampingFraction: 0.7) }

  /// Animation for card selection/deselection
  static var cardSelection: Animation { .spring(response: 0.6, dampingFraction: 0.75) }

  /// Animation for the entire card stack
  static var cardStack: Animation {
    .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)
  }
}
