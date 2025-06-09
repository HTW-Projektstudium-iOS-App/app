// Sources/Cardtier/Models/Card.swift
import CoreLocation
import Foundation

/// Represents a business card with front and back content plus metadata
public struct Card: Identifiable {
    /// Text displayed on the front of the card
    public let frontText: String
    
    /// Unique identifier for the card
    public let id: UUID
    
    /// Text displayed on the back of the card
    public let backText: String
    
    /// Date when the card was collected
    public let collectionDate: Date
    
    /// Geographic location where the card was collected
    public let collectionLocation: CLLocationCoordinate2D

    /// Creates a new business card
    /// - Parameters:
    ///   - frontText: Text for the front side
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - backText: Text for the back side
    ///   - collectionDate: When the card was collected
    ///   - collectionLocation: Where the card was collected
    public init(
        frontText: String,
        id: UUID = UUID(),
        backText: String,
        collectionDate: Date,
        collectionLocation: CLLocationCoordinate2D
    ) {
        self.frontText = frontText
        self.id = id
        self.backText = backText
        self.collectionDate = collectionDate
        self.collectionLocation = collectionLocation
    }
}
