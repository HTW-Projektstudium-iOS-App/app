import SwiftUI

// MARK: - Card Elements Utility

/// Utility struct containing reusable UI components for card designs
/// Ensures consistency and reduces code duplication across card types
struct CardElements {

    // MARK: - Shape Options

    /// Available shapes for logo containers
    public enum LogoShape {
        case oval
        case circle
        case square
    }

    // MARK: - Info Button

    /// Creates a standardized info button with consistent styling
    /// - Parameters:
    ///   - card: Card data for styling information
    ///   - action: Closure executed when button is tapped
    /// - Returns: Configured Button view with info icon
    static func infoButton(card: Card, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "info.circle")
                .font(CardDesign.Typography.titleFont)
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Logo Factory

    /// Creates a layered logo with shadows, highlights, and flexible content
    /// Includes fallback system: custom logo → placeholder → system icon
    static func logo(
        index: Int = 0,
        logos: [UIImage]? = nil,
        color: Color?,
        shape: LogoShape = .oval,
        width: CGFloat = CardElementsConstants.defaultLogoWidth,
        height: CGFloat = CardElementsConstants.defaultLogoHeight,
        contentWidth: CGFloat = CardElementsConstants.defaultLogoContentWidth,
        contentHeight: CGFloat = CardElementsConstants.defaultLogoContentHeight
    ) -> some View {
        ZStack {
            // Background shape with semi-transparent dark fill
            Group {
                switch shape {
                case .oval:
                    Ellipse()
                        .fill(Color.black.opacity(CardElementsConstants.logoBackgroundOpacity))
                case .circle:
                    Circle()
                        .fill(Color.black.opacity(CardElementsConstants.logoBackgroundOpacity))
                case .square:
                    Rectangle()
                        .fill(Color.black.opacity(CardElementsConstants.logoBackgroundOpacity))
                }
            }
            .frame(width: width, height: height)

            // Inner highlight for 3D depth effect
            Group {
                switch shape {
                case .oval:
                    Ellipse()
                        .fill(Color.white.opacity(CardElementsConstants.logoHighlightOpacity))
                case .circle:
                    Circle()
                        .fill(Color.white.opacity(CardElementsConstants.logoHighlightOpacity))
                case .square:
                    Rectangle()
                        .fill(Color.white.opacity(CardElementsConstants.logoHighlightOpacity))
                }
            }
            .frame(width: width - 2, height: height - 2)

            // Subtle shadow border for additional depth
            Group {
                switch shape {
                case .oval:
                    Ellipse()
                        .stroke(Color.black.opacity(CardElementsConstants.logoStrokeOpacity), lineWidth: CardElementsConstants.logoStrokeLineWidth)
                case .circle:
                    Circle()
                        .stroke(Color.black.opacity(CardElementsConstants.logoStrokeOpacity), lineWidth: CardElementsConstants.logoStrokeLineWidth)
                case .square:
                    Rectangle()
                        .stroke(Color.black.opacity(CardElementsConstants.logoStrokeOpacity), lineWidth: CardElementsConstants.logoStrokeLineWidth)
                }
            }
            .frame(width: width - 4, height: height - 4)
            .blur(radius: 2)

            // Content with intelligent fallback system
            if let logoArray = logos, index < logoArray.count {
                // Primary: Use provided logo from array
                Image(uiImage: logoArray[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: contentWidth, height: contentHeight)
            } else if let placeholderURL = Bundle.main.url(
                forResource: CardElementsConstants.placeholderImageName,
                withExtension: CardElementsConstants.placeholderImageExtension
            ),
                let placeholderImage = UIImage(
                    contentsOfFile: placeholderURL.path
                )
            {
                // Fallback: Use bundled placeholder image
                Image(uiImage: placeholderImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: contentWidth, height: contentHeight)
            } else {
                // Final fallback: System Apple logo with color styling
                Image(systemName: CardElementsConstants.fallbackSystemLogoName).imageScale(.large)
                    .foregroundColor(color?.opacity(0.8) ?? .white.opacity(0.8))
            }
        }
        // External drop shadow for visual separation
        .shadow(
            color: Color.black.opacity(CardElementsConstants.logoShadowOpacity),
            radius: CardElementsConstants.logoShadowRadius,
            x: 0,
            y: CardElementsConstants.logoShadowYOffset
        )
    }
}
