// Sources/Cardtier/ViewModels/CardStackViewModel.swift
import SwiftUI
import Combine
import CoreLocation

/// View model to manage the card stack state and operations
public class CardStackViewModel: ObservableObject {
    /// Currently loaded cards
    @Published public var cards: [Card] = []
    
    /// Dictionary tracking which cards are flipped
    @Published public var flipped: [UUID: Bool] = [:]
    
    /// Dictionary tracking which cards show info
    @Published public var showInfo: [UUID: Bool] = [:]
    
    /// Currently focused card ID (if any)
    @Published public var focusedCardID: UUID? = nil
    
    /// Whether a drag operation is in progress
    @Published public var isDragging = false

    /// Initializes with sample cards for preview/testing
    /// - Parameter withSampleData: Whether to load sample data
    public init(withSampleData: Bool = false) {
        if withSampleData {
            self.cards = Self.sampleCards
        }
    }

    /// Resets the focused card state
    public func resetFocusedCard() {
        withAnimation(CardDesign.Animation.focusTransition) {
            focusedCardID = nil
            flipped = [:]
            showInfo = [:]
        }
    }

    /// Creates a binding for a specific card property
    /// - Parameters:
    ///   - card: The card to create a binding for
    ///   - keyPath: KeyPath to the dictionary property in the view model
    ///   - defaultValue: Default value if no entry exists
    /// - Returns: A binding to the specific card's property
    public func bindingForCard<T>(_ card: Card, from keyPath: ReferenceWritableKeyPath<CardStackViewModel, [UUID: T]>, defaultValue: T) -> Binding<T> {
        Binding(
            get: { self[keyPath: keyPath][card.id] ?? defaultValue },
            set: { self[keyPath: keyPath][card.id] = $0 }
        )
    }

    /// Returns the currently focused card, if any
    public var focusedCard: Card? {
        focusedCardID.flatMap { id in cards.first(where: { $0.id == id }) }
    }

    /// Sample cards for preview/testing
    private static var sampleCards: [Card] = [
        Card(frontText: "John Doe", backText: "Acme Corp\nProduct Manager", 
             collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)),
        Card(frontText: "Jane Smith", backText: "Tech Solutions\nSoftware Engineer", 
             collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)),
        Card(frontText: "Alice Johnson", backText: "Global Industries\nData Scientist", 
             collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)),
        Card(frontText: "Bob Brown", backText: "Innovatech\nUX Designer", 
             collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
        Card(frontText: "Charlie Green", backText: "Future Tech\nAI Researcher", 
             collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)),
        Card(frontText: "Diana White", backText: "Health Solutions\nMedical Advisor",
             collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        Card(frontText: "Ethan Black", backText: "Finance Group\nInvestment Analyst",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)),
        Card(frontText: "Fiona Blue", backText: "Creative Agency\nMarketing Director",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 39.7392, longitude: -104.9903)),
        Card(frontText: "George Yellow", backText: "Logistics Co\nSupply Chain Manager",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)),
        Card(frontText: "Hannah Purple", backText: "Education Org\nCurriculum Developer",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589)),
        Card(frontText: "Ian Orange", backText: "Retail Group\nStore Manager",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431)),
        Card(frontText: "Julia Pink", backText: "Entertainment Inc\nEvent Coordinator",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 25.7617, longitude: -80.1918)),
        Card(frontText: "Kevin Gray", backText: "Construction Ltd\nProject Manager",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740)),
        Card(frontText: "Laura Silver", backText: "Consulting Firm\nBusiness Analyst",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 38.9072, longitude: -77.0369)),
        Card(frontText: "Mike Gold", backText: "Energy Corp\nEnvironmental Engineer",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 29.7604, longitude: -95.3698)),
        Card(frontText: "Nina Bronze", backText: "Travel Agency\nTour Planner",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 45.5231, longitude: -122.6765)),
        Card(frontText: "Oscar Copper", backText: "Real Estate\nProperty Manager",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 36.1699, longitude: -115.1398)),
        Card(frontText: "Paula Steel", backText: "Hospitality Group\nHotel Manager",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)),
        Card(frontText: "Quinn Bronze", backText: "Nonprofit Org\nCommunity Outreach",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)),
        Card(frontText: "Rachel Silver", backText: "Tech Startup\nProduct Designer",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        Card(frontText: "Sam Gold", backText: "E-commerce\nDigital Marketing",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
        Card(frontText: "Tina Green", backText: "Fashion Brand\nCreative Director",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)),
        Card(frontText: "Victor Blue", backText: "Automotive Co\nSales Executive",
                collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589)),
    ]
}
