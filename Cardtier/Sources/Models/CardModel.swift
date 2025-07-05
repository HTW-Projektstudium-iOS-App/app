import CoreLocation
import Foundation
import SwiftUI

/// Stores contact details for a business card, such as email, phone, fax, website, and LinkedIn.
public struct ContactInformation: Codable {
    /// Email address (optional)
    public let email: String?
    
    /// Phone number (optional)
    public let phoneNumber: String?
    
    /// Fax number (optional)
    public let faxNumber: String?
    
    /// Website URL (optional)
    public let websiteURL: URL?
    
    /// LinkedIn profile URL (optional)
    public let linkedInURL: URL?
    
    /// Initializes a new contact information object with all fields optional.
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
    
    /// Returns true if at least one contact field is present.
    public var hasAnyInformation: Bool {
        email != nil || phoneNumber != nil || faxNumber != nil ||
        websiteURL != nil || linkedInURL != nil
    }
}

/// Stores address details for a business card, such as street, city, state, postal code, and country.
public struct Address: Codable {
    /// Street name and number (optional)
    public let street: String?
    
    /// City name (optional)
    public let city: String?
    
    /// State or province (optional)
    public let state: String?
    
    /// Postal or ZIP code (optional)
    public let postalCode: String?
    
    /// Country (optional)
    public let country: String?
    
    /// Initializes a new address object with all fields optional.
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
    
    /// Returns true if at least one address field is present.
    public var hasAddressInformation: Bool {
        street != nil || city != nil || state != nil ||
        postalCode != nil || country != nil
    }
    
    /// Returns a formatted, multi-line address string, or nil if no fields are present.
    public var formattedAddress: String? {
        var components: [String] = []
        
        // Add street if available
        if let street = street { components.append(street) }
        
        // Build city/state/postal line
        var cityLine = ""
        if let city = city { cityLine += city }
        if let state = state { cityLine += cityLine.isEmpty ? state : ", \(state)" }
        if let postalCode = postalCode {
            cityLine += cityLine.isEmpty ? postalCode : " \(postalCode)"
        }
        if !cityLine.isEmpty { components.append(cityLine) }
        
        // Add country if available
        if let country = country { components.append(country) }
        
        // Return joined string or nil if empty
        return components.isEmpty ? nil : components.joined(separator: "\n")
    }
}

/// Defines the visual style for a business card, including colors, font, and design type.
public struct CardStyle: Codable {
    /// Main color for the card background and elements.
    public let primaryColor: Color
    
    /// Secondary color for highlights or text (optional).
    public let secondaryColor: Color?
    
    /// Font name for card text (optional).
    public let fontName: String?
    
    /// Design style (e.g., modern, minimal, traditional).
    public let designStyle: CardDesignType
    
    /// Initializes a new card style with optional secondary color and font.
    public init(
        primaryColor: Color = .white,
        secondaryColor: Color? = nil,
        fontName: String? = nil,
        designStyle: CardDesignType = .modern
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.fontName = fontName
        self.designStyle = designStyle
    }
    
    // Coding keys for custom encoding/decoding of colors as hex strings.
    private enum CodingKeys: String, CodingKey {
        case primaryColorHex, secondaryColorHex, fontName, designStyle
    }
    
    /// Encodes the style, converting colors to hex strings for serialization.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(primaryColor.toHex, forKey: .primaryColorHex)
        if let secondaryColor = secondaryColor {
            try container.encode(secondaryColor.toHex, forKey: .secondaryColorHex)
        }
        try container.encode(fontName, forKey: .fontName)
        try container.encode(designStyle, forKey: .designStyle)
    }
    
    /// Decodes the style, converting hex strings back to Color.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let primaryHex = try container.decode(String.self, forKey: .primaryColorHex)
        primaryColor = Color(hex: primaryHex) ?? .white
        
        if container.contains(.secondaryColorHex) {
            let secondaryHex = try container.decode(String.self, forKey: .secondaryColorHex)
            secondaryColor = Color(hex: secondaryHex)
        } else {
            secondaryColor = nil
        }
        
        fontName = try container.decodeIfPresent(String.self, forKey: .fontName)
        designStyle = try container.decode(CardDesignType.self, forKey: .designStyle)
    }
}

/// Enum for the overall design style of a card.
public enum CardDesignType: String, Codable {
    case modern
    case minimal
    case traditional
    // Extend with more design types as needed
}

/// Represents a business card with all professional and visual information.
public struct Card: Identifiable, Codable {
    /// Unique identifier for the card.
    public let id: UUID
    
    /// Full name of the cardholder.
    public let name: String
    
    /// Professional title (e.g., "CEO", optional).
    public let title: String?
    
    /// Role or position (e.g., "Executive Management", optional).
    public let role: String?
    
    /// Company or organization name (optional).
    public let company: String?
    
    /// Contact information (email, phone, etc.).
    public let contactInformation: ContactInformation
    
    /// Business address (optional).
    public let businessAddress: Address?
    
    /// Personal/private address (optional).
    public let personalAddress: Address?
    
    /// Company slogan or tagline (optional).
    public let slogan: String?
    
    /// Array of logos or images to display (optional).
    public let logos: [UIImage]?
    
    /// Visual styling for the card.
    public let style: CardStyle
    
    /// Date when the card was collected.
    public let collectionDate: Date
    
    /// Geographic location where the card was collected.
    public let collectionLocation: CLLocationCoordinate2D
    
    /// Initializes a new business card with all details.
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
        logos: [UIImage]? = nil,
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
        self.logos = logos
        self.style = style
        self.collectionDate = collectionDate
        self.collectionLocation = collectionLocation
    }
    
    // Coding keys for custom encoding/decoding, including location and logo images.
    private enum CodingKeys: String, CodingKey {
        case id, name, title, role, company, contactInformation
        case businessAddress, personalAddress, slogan, logos, style
        case collectionDate, latitude, longitude
    }
    
    /// Encodes the card, converting images to Data and location to latitude/longitude.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(title, forKey: .title)
        try container.encode(role, forKey: .role)
        try container.encode(company, forKey: .company)
        try container.encode(contactInformation, forKey: .contactInformation)
        try container.encode(businessAddress, forKey: .businessAddress)
        try container.encode(personalAddress, forKey: .personalAddress)
        try container.encode(slogan, forKey: .slogan)
        
        // Convert UIImage array to Data array for encoding
        if let logos = logos, !logos.isEmpty {
            var logoDataArray: [Data] = []
            for logo in logos {
                if let imageData = logo.pngData() {
                    logoDataArray.append(imageData)
                }
            }
            try container.encode(logoDataArray, forKey: .logos)
        }
        
        try container.encode(style, forKey: .style)
        try container.encode(collectionDate, forKey: .collectionDate)
        try container.encode(collectionLocation.latitude, forKey: .latitude)
        try container.encode(collectionLocation.longitude, forKey: .longitude)
    }
    
    /// Decodes the card, converting Data arrays back to UIImage and reconstructing the location.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        role = try container.decodeIfPresent(String.self, forKey: .role)
        company = try container.decodeIfPresent(String.self, forKey: .company)
        contactInformation = try container.decode(ContactInformation.self, forKey: .contactInformation)
        businessAddress = try container.decodeIfPresent(Address.self, forKey: .businessAddress)
        personalAddress = try container.decodeIfPresent(Address.self, forKey: .personalAddress)
        slogan = try container.decodeIfPresent(String.self, forKey: .slogan)
        
        // Convert Data array back to UIImage array
        if let logoDataArray = try container.decodeIfPresent([Data].self, forKey: .logos) {
            var decodedLogos: [UIImage] = []
            for logoData in logoDataArray {
                if let image = UIImage(data: logoData) {
                    decodedLogos.append(image)
                }
            }
            logos = decodedLogos.isEmpty ? nil : decodedLogos
        } else {
            logos = nil
        }
        
        style = try container.decode(CardStyle.self, forKey: .style)
        collectionDate = try container.decode(Date.self, forKey: .collectionDate)
        
        // Decode latitude and longitude to CLLocationCoordinate2D
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        collectionLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
