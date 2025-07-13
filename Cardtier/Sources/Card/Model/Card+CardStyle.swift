import SwiftUI

extension Card {
  /// Defines the overall design style of a card
  enum DesignType: String, Codable {
    case modern
    case minimal
    case traditional
  }

  /// Visual style for a business card
  struct CardStyle: Codable {
    /// Primary color for the card
    private let primaryColorHex: String

    /// Secondary color for the card
    private let secondaryColorHex: String?

    /// Primary color for the card
    var primaryColor: Color {
      Color(hexString: primaryColorHex) ?? .white
    }

    /// Secondary color for the card
    var secondaryColor: Color? {
      guard let hex = secondaryColorHex else { return nil }
      return Color(hexString: hex)
    }

    /// Font name for the card text
    let fontName: String?

    /// Design style for the card (Modern, Minimal, etc.)
    let designStyle: DesignType

    /// Creates a card style
    init(
      primaryColor: Color = .white,
      secondaryColor: Color? = nil,
      fontName: String? = nil,
      designStyle: DesignType = .modern
    ) {
      self.primaryColorHex = primaryColor.hexString
      self.secondaryColorHex = secondaryColor?.hexString
      self.fontName = fontName
      self.designStyle = designStyle
    }
  }
}
