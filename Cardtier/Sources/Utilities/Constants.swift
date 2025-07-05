// Sources/Cardtier/Utilities/Constants.swift
import SwiftUI



/// Constants used for card elements such as logos, images, and placeholders
public enum CardElementsConstants {
    public static let defaultLogoWidth: CGFloat = 95
    public static let defaultLogoHeight: CGFloat = 50
    public static let defaultLogoContentWidth: CGFloat = 85
    public static let defaultLogoContentHeight: CGFloat = 40

    public static let logoBackgroundOpacity: Double = 0.25
    public static let logoHighlightOpacity: Double = 0.15
    public static let logoStrokeOpacity: Double = 0.2
    public static let logoStrokeLineWidth: CGFloat = 1.5
    public static let logoShadowOpacity: Double = 0.25
    public static let logoShadowRadius: CGFloat = 3
    public static let logoShadowYOffset: CGFloat = 2

    public static let fallbackSystemLogoName = "apple.logo"
    public static let placeholderImageName = "noplaceholder"
    public static let placeholderImageExtension = "png"
}

/// Constants used for the card info sheet, including font sizes, spacings, and other UI elements
public enum CardInfoSheetConstants {
    public static let headerFontSize: CGFloat = 20
    public static let titleFontSize: CGFloat = 16
    public static let companyFontSize: CGFloat = 14
    public static let sectionTitleFontSize: CGFloat = 16
    public static let sectionTitleFontWeight: Font.Weight = .semibold
    public static let itemFontSize: CGFloat = 14
    public static let itemFontWeight: Font.Weight = .regular
    public static let iconFrameWidth: CGFloat = 20
    public static let dividerOpacity: Double = 0.5
    public static let spacingAdjustment: CGFloat = 2
    public static let coordinateFormat: String = "%.4f"
}

// Card stack animation constants
public enum CardStackAnimationConstants {
    public static let yOffsetMultiplier: CGFloat = -28
    public static let scaleDepthMultiplier: CGFloat = 0.06
    public static let blurDepthMultiplier: CGFloat = 3.5
    public static let opacityDepthMultiplier: CGFloat = 0.13
    public static let tiltMultiplier: Double = 2.7
    public static let shadowBase: CGFloat = 8
    public static let shadowDepthMultiplier: CGFloat = 3
    public static let focusedShadowOpacity: Double = 0.28
    public static let unfocusedShadowOpacityBase: Double = 0.13
    public static let unfocusedShadowOpacityDepth: Double = 0.08
    public static let focusedShadowYOffset: CGFloat = 10
    public static let perspective: CGFloat = 0.5
    public static let animationResponse: Double = 0.38
    public static let animationDamping: Double = 0.84
}

// Card stack view-specific constants
public enum CardStackViewConstants {
    public static let focusedSpacerHeight: CGFloat = 250
    public static let scrollEndTimerInterval: TimeInterval = 0.25
    public static let scrollEndThreshold: TimeInterval = 0.2
    public static let scrollVelocityWindDownDuration: Double = 0.6
    public static let velocityNormalizationFactor: CGFloat = 0.0015
    public static let velocityClamp: CGFloat = 3.0
    public static let stackBottomPadding: CGFloat = CardDesign.Layout.cardHeight + 40
    public static let visibleCardsCount: Int = 3
    public static let collapsedStackHeight: CGFloat = 40
    public static let collapsedCardSpacing: CGFloat = 2
}

// Card view-specific constants
public enum CardViewConstants {
    public static let cornerRadius: CGFloat = 0
    public static let borderOpacity: Double = 0.15
    public static let borderLineWidth: CGFloat = 0.7
    public static let backgroundShadowOpacity: Double = 0.08
    public static let backgroundShadowYOffset: CGFloat = 3
    public static let backgroundShadowBlur: CGFloat = 5
    public static let innerLightReflectionOpacity: Double = 0.35
    public static let shadowFocusedOpacity: Double = 0.25
    public static let shadowUnfocusedOpacity: Double = 0.15
    public static let shadowFocusedRadius: CGFloat = 12
    public static let shadowUnfocusedRadius: CGFloat = 8
    public static let shadowFocusedYOffset: CGFloat = 6
    public static let shadowUnfocusedYOffset: CGFloat = 4
}

// Card view animation-specific constants
public enum CardViewAnimationConstants {
    // ScrollingAnimation
    public static let randomFactorMin: Double = -0.5
    public static let randomFactorMax: Double = 0.5
    public static let secondaryRandomFactorMin: Double = -0.3
    public static let secondaryRandomFactorMax: Double = 0.3
    public static let opacityBase: Double = 0.98
    public static let opacityIntensity: Double = 0.02
    public static let scaleBase: Double = 0.997
    public static let scaleIntensity: Double = 0.003
    public static let rotationMultiplier1: Double = 0.4
    public static let rotationMultiplier2: Double = 0.3
    public static let rotation3DMultiplier1: Double = 0.3
    public static let rotation3DMultiplier2: Double = 0.2
    public static let rotation3DMultiplier3: Double = 0.15
    public static let rotation3DMultiplier4: Double = 0.2
    public static let offsetXMultiplier1: Double = 0.25
    public static let offsetXMultiplier2: Double = 0.2
    public static let offsetYMultiplier1: Double = 0.1
    public static let offsetYMultiplier2: Double = 0.15
    public static let rotation3DAxis1: (x: Double, y: Double, z: Double) = (0.1, 0.8, 0.1)
    public static let rotation3DAxis2: (x: Double, y: Double, z: Double) = (0.3, 0.1, 0)
    public static let rotation3DAnchor: UnitPoint = .center
    public static let rotation3DPerspective: CGFloat = 0.2
    public static let rotation3DAnchorTrailing: UnitPoint = .trailing
    public static let animationSpringResponse: Double = 0.35
    public static let animationSpringDamping: Double = 0.7
    public static let animationEaseOutDuration: Double = 0.2
    public static let windDownMultiplier1: Double = 0.6
    public static let windDownMultiplier2: Double = 0.5
    public static let windDownMultiplier3: Double = 0.8
    public static let windDownMultiplier4: Double = 1.0
    public static let windDownDampingOffset1: Double = 0.1
    public static let windDownDampingOffset2: Double = 0.15

    // BreathingAnimation
    public static let breathingRandomDirectionMin: Double = -0.6
    public static let breathingRandomDirectionMax: Double = 0.6
    public static let breathingScale: CGFloat = 1.0025
    public static let breathingRotation1: Double = 0.12
    public static let breathingRotation2: Double = -0.08
    public static let breathingRotation3: Double = -0.1
    public static let breathingRotation4: Double = 0.06
    public static let breathingAxis1: (x: Double, y: Double, z: Double) = (0.1, 1, 0)
    public static let breathingAxis2: (x: Double, y: Double, z: Double) = (1, 0.2, 0)
    public static let breathingPerspective: CGFloat = 0.2
    public static let breathingSpringResponseBase: Double = 0.9
    public static let breathingSpringResponseRange: Double = 0.2
    public static let breathingSpringDamping: Double = 0.7
    public static let breathingEaseOutDuration: Double = 0.2
}

/// Design constants used throughout the focused card view
public enum FocusedCardViewConstants {
    public static let zIndex: Double = 1000
    public static let shadowRadius: CGFloat = 10
    public static let shadowX: CGFloat = 0
    public static let shadowY: CGFloat = 3
    public static let rotationDegrees: Double = 1
    public static let rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (1.0, 0, 0)
    public static let rotationPerspective: CGFloat = 0.1
    public static let insertionDuration: Double = 0.4
    public static let removalDuration: Double = 0.35
    public static let stackAnimation: Animation = .spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)
}

/// Design constants used throughout the minimal card design
public enum MinimalCardDesignConstants {
    public static let borderOpacity: Double = 0.2
    public static let borderLineWidth: CGFloat = 0.5
    public static let monogramFontName: String = "Zapfino"
    public static let monogramFontSize: CGFloat = 60
    public static let monogramFontWeight: Font.Weight = .thin
    public static let monogramOpacity: Double = 0.25
    public static let monogramYOffset: CGFloat = 10
    public static let nameFontSize: CGFloat = 18
    public static let nameFontWeight: Font.Weight = .medium
    public static let roleFontSize: CGFloat = 16
    public static let vStackSpacing: CGFloat = 2
    public static let infoButtonBottomPadding: CGFloat = 4
    public static let infoButtonTrailingPadding: CGFloat = 4
    public static let companyFontSize: CGFloat = 14
    public static let companyFontWeight: Font.Weight = .bold
    public static let companyTopPadding: CGFloat = 80
    public static let socialIconSpacing: CGFloat = 5
    public static let socialIconCircleOpacity: Double = 0.5
    public static let socialIconCircleSize: CGFloat = 28
    public static let socialIconFontSize: CGFloat = 11
    public static let socialIconsVStackSpacing: CGFloat = 8
    public static let socialIconsHStackSpacing: CGFloat = 16
    public static let dividerWidth: CGFloat = 1
    public static let dividerHeight: CGFloat = 50
    public static let contactVStackSpacing: CGFloat = 5
    public static let contactFontSize: CGFloat = 12
    public static let contentHStackPadding: CGFloat = 16
    public static let contentBottomPadding: CGFloat = 20
    public static let backContentVStackSpacing: CGFloat = 0
    public static let frameMaxHeight: CGFloat = .infinity
}

/// Design constants used throughout the modern card design
public enum ModernCardDesignConstants {
    public static let logoWidth: CGFloat = 30
    public static let logoHeight: CGFloat = 30
    public static let logoContentWidth: CGFloat = 25
    public static let logoContentHeight: CGFloat = 25
    public static let headerFontSize: CGFloat = 12
    public static let nameFontSize: CGFloat = 28
    public static let nameFontWeight: Font.Weight = .black
    public static let contactLogoWidth: CGFloat = 70
    public static let contactLogoHeight: CGFloat = 70
    public static let contactLogoContentWidth: CGFloat = 60
    public static let contactLogoContentHeight: CGFloat = 60
    public static let contactLabelFontSize: CGFloat = 10
    public static let contactLabelFontWeight: Font.Weight = .bold
    public static let contactValueFontSize: CGFloat = 10
    public static let bulletSpacing: CGFloat = 2
    public static let bulletFontSize: CGFloat = 10
    public static let bulletSymbolSpacing: CGFloat = 8
    public static let backLogoSpacings: CGFloat = 10
    public static let backLogoSmall: CGFloat = 45
    public static let backLogoMedium: CGFloat = 55
    public static let backLogoLarge: CGFloat = 65
    public static let backLogoContentSmall: CGFloat = 35
    public static let backLogoContentMedium: CGFloat = 45
    public static let backLogoContentLarge: CGFloat = 55
}

/// Design constants used throughout the traditional card design
public enum TraditionalCardDesignConstants {
    public static let headerFontSize: CGFloat = 12
    public static let nameFontSize: CGFloat = 32
    public static let nameFontWeight: Font.Weight = .black
    public static let nameBottomPadding: CGFloat = 0
    public static let contentPadding: CGFloat = 16
    public static let topPadding: CGFloat = 16
    public static let bottomPadding: CGFloat = 16
    public static let infoButtonLeadingPadding: CGFloat = 16
    public static let backBackgroundOpacity: Double = 0.15
    public static let logoWidth: CGFloat = 95
    public static let logoHeight: CGFloat = 50
    public static let logoContentWidth: CGFloat = 85
    public static let logoContentHeight: CGFloat = 40
    public static let logoStackSpacing: CGFloat = -10
    public static let logoHStackSpacing: CGFloat = 50
}









/// Design constants used throughout the card stack implementation
public enum CardDesign {
    /// Animation configurations
    public enum Animation {
            /// Standard animation for card focus/unfocus transitions
            public static let focusTransition: SwiftUI.Animation = .spring(response: 0.3, dampingFraction: 0.7)
            
            /// Animation for card flip transitions
            public static let flipTransition: SwiftUI.Animation = .spring(response: 0.5, dampingFraction: 0.7)
            
            /// Animation for card selection/deselection
            public static let selectionTransition: SwiftUI.Animation = .spring(response: 0.6, dampingFraction: 0.75)
            
            /// Animation for the entire card stack
            public static let stackAnimation: SwiftUI.Animation = .spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.3)
            
            /// Smooth transition when scrolling stops
            public static let scrollEndTransition: SwiftUI.Animation = .easeOut(duration: 0.8)
            
            /// Duration for animations to gracefully wind down
            public static let windDownDuration: Double = 0.7
            
            /// Damping fraction for smooth animation endings
            public static let windDownDamping: Double = 0.65
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
        
        /// Offset for stacked cards
        public static let cardStackOffset: CGFloat = 10
        
        /// Top padding for the focused card
        public static let focusedCardTopPadding: CGFloat = -20
        
        /// Horizontal padding for cards
        public static let horizontalPadding: CGFloat = 20
        
        /// Top padding for the entire stack
        public static let stackTopPadding: CGFloat = 180
        
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
