import SwiftUI

/// Utility struct containing reusable UI components for card designs
/// Ensures consistency and reduces code duplication across card types
struct CardElements {

  /// Available shapes for logo containers
  enum LogoShape {
    case oval
    case circle
    case square
  }

  // MARK: - Logo Factory

  /// Creates a layered logo with shadows, highlights, and flexible content
  /// Includes fallback system: custom logo → placeholder → system icon
  static func logo(
    index: Int = 0,
    logos: [Data]? = nil,
    color: Color?,
    shape: LogoShape = .oval,
    width: CGFloat = 95,
    height: CGFloat = 50,
    contentWidth: CGFloat = 85,
    contentHeight: CGFloat = 40
  ) -> some View {
    ZStack {
      Group {
        switch shape {
        case .oval:
          Ellipse().fill(Color.black.opacity(0.1))
        case .circle:
          Circle().fill(Color.black.opacity(0.1))
        case .square:
          Rectangle().fill(Color.black.opacity(0.1))
        }
      }
      .frame(width: width, height: height)

      Group {
        switch shape {
        case .oval:
          Ellipse().fill(Color.white.opacity(0.15))
        case .circle:
          Circle().fill(Color.white.opacity(0.15))
        case .square:
          Rectangle().fill(Color.white.opacity(0.15))
        }
      }
      .frame(width: width - 2, height: height - 2)

      Group {
        switch shape {
        case .oval:
          Ellipse().stroke(Color.black.opacity(0.2), lineWidth: 1.5)
        case .circle:
          Circle().stroke(Color.black.opacity(0.2), lineWidth: 1.5)
        case .square:
          Rectangle().stroke(Color.black.opacity(0.2), lineWidth: 1.5)
        }
      }
      .frame(width: width - 4, height: height - 4)
      .blur(radius: 2)

      if let logoArray = logos, index < logoArray.count {
        Image(uiImage: UIImage(data: logoArray[index])!)
          .resizable()
          .scaledToFit()
          .frame(width: contentWidth, height: contentHeight)
      } else if let placeholderURL = Bundle.main.url(
        forResource: "noplaceholder", withExtension: "png"),
        let placeholderImage = UIImage(contentsOfFile: placeholderURL.path)
      {
        Image(uiImage: placeholderImage)
          .resizable()
          .scaledToFit()
          .frame(width: contentWidth, height: contentHeight)
      } else {
        Image(systemName: "apple.logo")
          .imageScale(.large)
          .foregroundColor(color?.opacity(0.8) ?? .white.opacity(0.8))
      }
    }
    .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 2)
  }

  static func customFont(name: String?, size: CGFloat, weight: Font.Weight = .regular) -> Font {
    guard let name = name, !name.isEmpty else {
      return .system(size: size, weight: weight)
    }
    return .custom(name, size: size, relativeTo: .body)
  }
}
