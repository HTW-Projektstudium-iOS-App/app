// Sources/Cardtier/Utilities/Constants.swift
import SwiftUI

/// Design constants used throughout the card stack implementation
public enum CardDesign {
    /// Dimensions and layout values for card stack
    public enum Layout {
        /// Height of each card in points
        public static let cardHeight: CGFloat = 180
        
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
    }
    
    /// Animation configurations
    public enum Animation {
        /// Standard animation for card focus/unfocus transitions
        public static let focusTransition: SwiftUI.Animation = .spring(response: 0.3,
                                                                      dampingFraction: 0.7)
    }
}
