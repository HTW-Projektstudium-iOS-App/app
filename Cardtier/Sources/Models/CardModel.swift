// Sources/Cardtier/Models/CardModel.swift
import CoreLocation
import Foundation
import UIKit

/// Contact information for a business card
public struct ContactInformation {
    /// Email address
    public let email: String?
    
    /// Phone number
    public let phoneNumber: String?
    
    /// Fax number
    public let faxNumber: String?
    
    /// Website URL
    public let websiteURL: URL?
    
    /// LinkedIn profile URL
    public let linkedInURL: URL?
    
    /// Creates contact information with optional fields
    public init(
        email: String? = nil,
        phoneNumber: String? = nil,
        faxNumber: String? = nil,
        websiteURL: URL? = nil,
        linkedInURL: URL? = nil
    ) {
        self.email = email
        self.phoneNumber = phoneNumber
        self.faxNumber = faxNumber
        self.websiteURL = websiteURL
        self.linkedInURL = linkedInURL
    }
    
    /// Check if any contact information is available
    public var hasAnyInformation: Bool {
        email != nil || phoneNumber != nil || faxNumber != nil ||
        websiteURL != nil || linkedInURL != nil
    }
}

/// Address information for a business card
public struct Address {
    /// Street name and number
    public let street: String?
    
    /// City name
    public let city: String?
    
    /// State or province
    public let state: String?
    
    /// Postal or ZIP code
    public let postalCode: String?
    
    /// Country
    public let country: String?
    
    /// Creates address information with optional fields
    public init(
        street: String? = nil,
        city: String? = nil,
        state: String? = nil,
        postalCode: String? = nil,
        country: String? = nil
    ) {
        self.street = street
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
    }
    
    /// Check if any address information is available
    public var hasAnyInformation: Bool {
        street != nil || city != nil || state != nil ||
        postalCode != nil || country != nil
    }
    
    /// Returns a formatted, multi-line address string
    public var formattedAddress: String? {
        var components: [String] = []
        
        if let street = street { components.append(street) }
        
        var cityLine = ""
        if let city = city { cityLine += city }
        if let state = state { cityLine += cityLine.isEmpty ? state : ", \(state)" }
        if let postalCode = postalCode {
            cityLine += cityLine.isEmpty ? postalCode : " \(postalCode)"
        }
        if !cityLine.isEmpty { components.append(cityLine) }
        
        if let country = country { components.append(country) }
        
        return components.isEmpty ? nil : components.joined(separator: "\n")
    }
}

/// Visual style for a business card
public struct CardStyle {
    /// Primary color for the card
    public let primaryColor: UIColor
    
    /// Secondary color for the card
    public let secondaryColor: UIColor?
    
    /// Font name for the card text
    public let fontName: String?
    
    /// Design style for the card (Modern, Minimal, etc.)
    public let designStyle: CardDesignType
    
    /// Creates a card style
    public init(
        primaryColor: UIColor = .white,
        secondaryColor: UIColor? = nil,
        fontName: String? = nil,
        designStyle: CardDesignType = .modern
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.fontName = fontName
        self.designStyle = designStyle
    }
}

/// Defines the overall design style of a card
public enum CardDesignType {
    case modern
    case minimal
    // Add more design types here as needed
}

/// Represents a business card with professional information and metadata
public struct Card: Identifiable {
    /// Unique identifier for the card
    public let id: UUID
    
    /// Full name of the person
    public let name: String
    
    /// Professional title (e.g., "CEO")
    public let title: String?
    
    /// Role or position (e.g., "Executive Management")
    public let role: String?
    
    /// Company or organization name
    public let company: String?
    
    /// Contact information (email, phone, etc.)
    public let contactInformation: ContactInformation
    
    /// Business/company address
    public let businessAddress: Address?
    
    /// Personal/private address
    public let personalAddress: Address?
    
    /// Company slogan or tagline
    public let slogan: String?
    
    /// Visual styling for the card
    public let style: CardStyle
    
    /// Date when the card was collected
    public let collectionDate: Date
    
    /// Geographic location where the card was collected
    public let collectionLocation: CLLocationCoordinate2D
    
    /// Creates a new business card with full details
    public init(
        id: UUID = UUID(),
        name: String,
        title: String? = nil,
        role: String? = nil,
        company: String? = nil,
        contactInformation: ContactInformation = ContactInformation(),
        businessAddress: Address? = nil,
        personalAddress: Address? = nil,
        slogan: String? = nil,
        style: CardStyle = CardStyle(),
        collectionDate: Date = Date(),
        collectionLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.role = role
        self.company = company
        self.contactInformation = contactInformation
        self.businessAddress = businessAddress
        self.personalAddress = personalAddress
        self.slogan = slogan
        self.style = style
        self.collectionDate = collectionDate
        self.collectionLocation = collectionLocation
    }
}
