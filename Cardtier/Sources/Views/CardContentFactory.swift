import SwiftUI

/// Factory for creating the appropriate card design with caching
struct CardContentFactory {
    // Cache to store created designs by card ID
    private static var designCache: [UUID: Any] = [:]

    static func makeDesign(for card: Card, showInfoAction: @escaping () -> Void)
        -> any CardContentDesign
    {
        // Check if we already have a cached design for this card
        if let cachedDesign = designCache[card.id] as? any CardContentDesign {
            return cachedDesign
        }

        // Create a new design based on style
        let design: any CardContentDesign
        switch card.style.designStyle {
        case .modern:
            design = ModernCardDesign(
                card: card,
                showInfoAction: showInfoAction
            )
        case .minimal:
            design = MinimalCardDesign(
                card: card,
                showInfoAction: showInfoAction
            )
        case .traditional:
            design = TraditionalCardDesign(
                card: card,
                showInfoAction: showInfoAction
            )
        }

        // Cache the new design
        designCache[card.id] = design
        return design
    }

    // Method to clear the cache if needed (e.g., when memory pressure is high)
    static func clearCache() {
        designCache.removeAll()
    }
}
