import SwiftUICore

// MARK: - Card Content Design Protocol

/// Main protocol defining the interface for card content designs
/// This protocol serves as a blueprint for creating different visual representations of cards
/// By implementing this protocol, you can create custom card designs while maintaining
/// a consistent interface for the card system
protocol CardContentDesign {
    
    // MARK: - Required Properties
    
    /// The card data model that contains all the information to be displayed
    /// This provides access to the card's content, metadata, and state
    var card: Card { get }
    
    /// Closure that gets called when the user requests to show additional card information
    /// This allows the card design to trigger info display without knowing the implementation details
    /// The action might show a modal, navigate to a detail view, or expand inline content
    var showInfoAction: () -> Void { get }
    
    // MARK: - Associated Types
    
    /// The SwiftUI view type used for the front face of the card
    /// This can be any View implementation, allowing for flexible front-side designs
    /// Examples: text-based content, images, charts, or complex layouts
    associatedtype FrontContent: View
    
    /// The SwiftUI view type used for the back face of the card
    /// This appears when the card is flipped and typically shows additional details
    /// Examples: explanations, definitions, answers, or supplementary information
    associatedtype BackContent: View
    
    // MARK: - Required Methods
    
    /// Creates and returns the view for the front side of the card
    /// This method should build the primary visual representation using the card data
    /// The returned view will be displayed as the default face of the card
    /// - Returns: A SwiftUI view representing the front content
    func frontContent() -> FrontContent
    
    /// Creates and returns the view for the back side of the card
    /// This method should build the secondary visual representation, often with more details
    /// The returned view is shown when the card is flipped or in answer mode
    /// - Returns: A SwiftUI view representing the back content
    func backContent() -> BackContent
}
