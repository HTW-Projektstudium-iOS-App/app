import SwiftUI

extension Color {
  /// Initialize a Color from a hex string
  public init?(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0

    Scanner(string: hex).scanHexInt64(&int)

    let alpha: UInt64
    let red: UInt64
    let green: UInt64
    let blue: UInt64

    switch hex.count {
    case 3:
      (red, green, blue, alpha) = ((int >> 8) & 0xF, (int >> 4) & 0xF, int & 0xF, 0xF)
      self.init(
        .sRGB,
        red: Double(red) / 15,
        green: Double(green) / 15,
        blue: Double(blue) / 15,
        opacity: Double(alpha) / 15
      )
    case 6:
      (red, green, blue, alpha) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 0xFF)
      self.init(
        .sRGB,
        red: Double(red) / 255,
        green: Double(green) / 255,
        blue: Double(blue) / 255,
        opacity: Double(alpha) / 255
      )
    case 8:
      (red, green, blue, alpha) = (
        (int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF
      )
      self.init(
        .sRGB,
        red: Double(red) / 255,
        green: Double(green) / 255,
        blue: Double(blue) / 255,
        opacity: Double(alpha) / 255
      )
    default:
      return nil
    }
  }

  /// Convert Color to hex string
  var hexString: String {
    let components = UIColor(self).cgColor.components
    let red: CGFloat = components?[0] ?? 0.0
    let green: CGFloat = components?[1] ?? 0.0
    let blue: CGFloat = components?[2] ?? 0.0
    let alpha: CGFloat = components?[3] ?? 0.0

    return String(
      format: "#%02X%02X%02X%02X",
      Int(red * 255),
      Int(green * 255),
      Int(blue * 255),
      Int(alpha * 255)
    )
  }
}
