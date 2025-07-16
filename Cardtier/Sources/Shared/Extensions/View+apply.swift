import SwiftUI

extension View {
  func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V {
    block(self)
  }
}
