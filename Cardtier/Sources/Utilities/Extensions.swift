import CoreGraphics
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
