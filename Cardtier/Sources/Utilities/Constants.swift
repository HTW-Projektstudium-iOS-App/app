import SwiftUI

// TODO: yeet this entire file

/// Design constants used throughout the card stack implementation
enum CardConstants {
  /// Dimensions and layout values for card stack
  enum Layout {
    /// Height of each card in points
    static let cardHeight: CGFloat = 180

    /// Aspect ratio for cards (width = height * aspectRatio)
    static let cardAspectRatio: CGFloat = 1.6

    /// Multiplier for card width relative to screen width
    static let cardWidthMultiplier: CGFloat = 0.95

    /// Maximum width for a card
    static let maxCardWidth: CGFloat = 500

    /// Corner radius for cards
    static let cornerRadius: CGFloat = 0

    /// Vertical offset between cards in the stack
    static let cardStackOffset: CGFloat = -120

    /// Top padding for the focused card
    static let focusedCardTopPadding: CGFloat = 20

    /// Horizontal padding for cards
    static let horizontalPadding: CGFloat = 20

    /// Top padding for the entire stack
    static let stackTopPadding: CGFloat = 260

    /// Minimum distance to recognize a drag gesture
    static let dragMinDistance: CGFloat = 1

    /// Scale factor for focused cards
    static let focusedScale: CGFloat = 1.05

    /// Vertical offset for unfocused cards
    static let unfocusedOffset: CGFloat = 100
  }

  /// Visual effects for cards
  enum Effects {
    /// Blur radius for focused cards
    static let focusedBlur: CGFloat = 0

    /// Blur radius for unfocused cards
    static let unfocusedBlur: CGFloat = 1.5

    /// Brightness adjustment for focused cards
    static let focusedBrightness: CGFloat = 0.03

    /// Brightness adjustment for unfocused cards
    static let unfocusedBrightness: CGFloat = -0.05

    /// Opacity for dimming unfocused cards
    static let dimOpacity: CGFloat = 0.15

    /// Shadow radius for focused cards
    static let focusedShadowRadius: CGFloat = 8

    /// Shadow radius for unfocused cards
    static let unfocusedShadowRadius: CGFloat = 4

    /// Shadow y-offset for focused cards
    static let focusedShadowY: CGFloat = 4

    /// Shadow y-offset for unfocused cards
    static let unfocusedShadowY: CGFloat = 2
  }

  /// Standard padding values
  enum Padding {
    /// Standard padding
    static let standard: CGFloat = 16

    /// Small padding
    static let small: CGFloat = 4

    /// Medium padding
    static let medium: CGFloat = 8

    /// Large padding
    static let large: CGFloat = 20
  }

  /// Typography styles
  enum Typography {
    /// Title font
    static let titleFont: Font = .title2

    /// Headline font
    static let headlineFont: Font = .headline

    /// Subheadline font
    static let subheadlineFont: Font = .subheadline

    /// Body font
    static let bodyFont: Font = .body

    /// Footnote font
    static let footnoteFont: Font = .footnote

    /// Caption font
    static let captionFont: Font = .caption
  }

  /// Color schemes
  enum Colors {
    /// Primary color
    static let primary: Color = .black

    /// Secondary color
    static let secondary: Color = .gray

    /// Background color
    static let background: Color = .white

    /// Accent color
    static let accent: Color = .blue
  }
}
