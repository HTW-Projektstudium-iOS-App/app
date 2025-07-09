import SwiftUI

extension Card {
  /// Defines the overall design style of a card
  enum DesignType: String, Codable {
    case modern
    case minimal
  }

  /// Visual style for a business card
  struct CardStyle: Codable {
    /// Primary color for the card
    let primaryColor: Color

    /// Secondary color for the card
    let secondaryColor: Color?

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
      self.primaryColor = primaryColor
      self.secondaryColor = secondaryColor
      self.fontName = fontName
      self.designStyle = designStyle
    }

    private enum CodingKeys: String, CodingKey {
      case primaryColorHex, secondaryColorHex, fontName, designStyle
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)

      try container.encode(primaryColor.hexString, forKey: .primaryColorHex)
      try container.encodeIfPresent(secondaryColor?.hexString, forKey: .secondaryColorHex)

      try container.encode(fontName, forKey: .fontName)
      try container.encode(designStyle, forKey: .designStyle)
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      let primaryHex = try container.decode(String.self, forKey: .primaryColorHex)
      self.primaryColor = Color(hexString: primaryHex) ?? .white

      let secondaryHex = try container.decodeIfPresent(String.self, forKey: .secondaryColorHex)
      self.secondaryColor = Color(hexString: secondaryHex ?? "")

      self.fontName = try container.decodeIfPresent(String.self, forKey: .fontName)
      self.designStyle = try container.decode(DesignType.self, forKey: .designStyle)
    }
  }
}
