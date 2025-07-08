import SwiftUI

/// Design constants used throughout the card stack implementation
public enum CardDesign {
  /// Animation configurations
  public enum Animation {
    /// Standard animation for card focus/unfocus transitions
    public static let focusTransition: SwiftUI.Animation = .spring(
      response: 0.3, dampingFraction: 0.7)

    /// Animation for card flip transitions
    public static let flipTransition: SwiftUI.Animation = .spring(
      response: 0.5, dampingFraction: 0.7)

    /// Animation for card selection/deselection
    public static let selectionTransition: SwiftUI.Animation = .spring(
      response: 0.6, dampingFraction: 0.75)

    /// Animation for the entire card stack
    public static let stackAnimation: SwiftUI.Animation = .spring(
      response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)
  }

  /// Dimensions and layout values for card stack
  public enum Layout {
    /// Height of each card in points
    public static let cardHeight: CGFloat = 180

    /// Aspect ratio for cards (width = height * aspectRatio)
    public static let cardAspectRatio: CGFloat = 1.6

    /// Multiplier for card width relative to screen width
    public static let cardWidthMultiplier: CGFloat = 0.95

    /// Maximum width for a card
    public static let maxCardWidth: CGFloat = 500

    /// Corner radius for cards
    public static let cornerRadius: CGFloat = 0

    /// Vertical offset between cards in the stack
    public static let cardStackOffset: CGFloat = -120

    /// Top padding for the focused card
    public static let focusedCardTopPadding: CGFloat = 20

    /// Horizontal padding for cards
    public static let horizontalPadding: CGFloat = 20

    /// Top padding for the entire stack
    public static let stackTopPadding: CGFloat = 260

    /// Minimum distance to recognize a drag gesture
    public static let dragMinDistance: CGFloat = 1

    /// Scale factor for focused cards
    public static let focusedScale: CGFloat = 1.05

    /// Vertical offset for unfocused cards
    public static let unfocusedOffset: CGFloat = 100
  }

  /// Visual effects for cards
  public enum Effects {
    /// Blur radius for focused cards
    public static let focusedBlur: CGFloat = 0

    /// Blur radius for unfocused cards
    public static let unfocusedBlur: CGFloat = 1.5

    /// Brightness adjustment for focused cards
    public static let focusedBrightness: CGFloat = 0.03

    /// Brightness adjustment for unfocused cards
    public static let unfocusedBrightness: CGFloat = -0.05

    /// Opacity for dimming unfocused cards
    public static let dimOpacity: CGFloat = 0.15

    /// Shadow radius for focused cards
    public static let focusedShadowRadius: CGFloat = 8

    /// Shadow radius for unfocused cards
    public static let unfocusedShadowRadius: CGFloat = 4

    /// Shadow y-offset for focused cards
    public static let focusedShadowY: CGFloat = 4

    /// Shadow y-offset for unfocused cards
    public static let unfocusedShadowY: CGFloat = 2
  }

  /// Standard padding values
  public enum Padding {
    /// Standard padding
    public static let standard: CGFloat = 16

    /// Small padding
    public static let small: CGFloat = 4

    /// Medium padding
    public static let medium: CGFloat = 8

    /// Large padding
    public static let large: CGFloat = 20
  }

  /// Typography styles
  public enum Typography {
    /// Title font
    public static let titleFont: Font = .title2

    /// Headline font
    public static let headlineFont: Font = .headline

    /// Subheadline font
    public static let subheadlineFont: Font = .subheadline

    /// Body font
    public static let bodyFont: Font = .body

    /// Footnote font
    public static let footnoteFont: Font = .footnote

    /// Caption font
    public static let captionFont: Font = .caption
  }

  /// Color schemes
  public enum Colors {
    /// Primary color
    public static let primary: Color = .black

    /// Secondary color
    public static let secondary: Color = .gray

    /// Background color
    public static let background: Color = .white

    /// Accent color
    public static let accent: Color = .blue
  }
}
