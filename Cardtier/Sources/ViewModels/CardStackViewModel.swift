import Combine
import CoreLocation
import SwiftUI

/// View model to manage the card stack state and operations
public class CardStackViewModel: ObservableObject {
  /// Currently loaded cards
  @Published public var cards: [Card] = []

  /// Dictionary tracking which cards are flipped
  @Published public var flipped: [UUID: Bool] = [:]

  /// Dictionary tracking which cards show info
  @Published public var showInfo: [UUID: Bool] = [:]

  /// Currently focused card ID (if any)
  @Published public var focusedCardID: UUID?

  /// Whether a drag operation is in progress
  @Published public var isDragging = false

  /// Initializes with sample cards for preview/testing
  /// - Parameter withSampleData: Whether to load sample data
  public init(withSampleData: Bool = false) {
    if withSampleData {
      self.cards = Card.sampleCards
    }
  }

  /// Resets the focused card state
  public func resetFocusedCard() {
    withAnimation(.cardFocus) {
      focusedCardID = nil
      flipped = [:]
      showInfo = [:]
    }
  }

  /// Creates a binding for a specific card property
  /// - Parameters:
  ///   - card: The card to create a binding for
  ///   - keyPath: KeyPath to the dictionary property in the view model
  ///   - defaultValue: Default value if no entry exists
  /// - Returns: A binding to the specific card's property
  public func bindingForCard<T>(
    _ card: Card, from keyPath: ReferenceWritableKeyPath<CardStackViewModel, [UUID: T]>,
    defaultValue: T
  ) -> Binding<T> {
    Binding(
      get: { self[keyPath: keyPath][card.id] ?? defaultValue },
      set: { self[keyPath: keyPath][card.id] = $0 }
    )
  }

  /// Returns the currently focused card, if any
  public var focusedCard: Card? {
    focusedCardID.flatMap { id in cards.first(where: { $0.id == id }) }
  }
}
