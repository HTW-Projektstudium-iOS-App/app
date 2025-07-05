import CoreGraphics
import UIKit
import SwiftUICore
extension CardElements {
    /// Converts a font name to a SwiftUI Font or falls back to the system font
    static func customFont(name: String?, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        guard let name = name, !name.isEmpty else {
            return .system(size: size, weight: weight)
        }
        return .custom(name, size: size, relativeTo: .body)
    }
}

// MARK: - Color Helpers
extension Color {
    /// Initializes a Color from a hex string (supports 3, 6, or 8 digit hex).
    public init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit, e.g. FFF)
            (r, g, b, a) = ((int >> 8) & 0xF, (int >> 4) & 0xF, int & 0xF, 0xF)
            self.init(
                .sRGB,
                red: Double(r) / 15,
                green: Double(g) / 15,
                blue: Double(b) / 15,
                opacity: Double(a) / 15
            )
        case 6: // RGB (24-bit, e.g. FFFFFF)
            (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 0xFF)
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a) / 255
            )
        case 8: // RGBA (32-bit, e.g. FFFFFFFF)
            (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a) / 255
            )
        default:
            return nil
        }
    }
    
    /// Converts a Color to a hex string (including alpha).
    var toHex: String {
        let components = UIColor(self).cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        let a: CGFloat = components?[3] ?? 0.0
        
        return String(
            format: "#%02X%02X%02X%02X",
            Int(r * 255),
            Int(g * 255),
            Int(b * 255),
            Int(a * 255)
        )
    }
}
