import CoreLocation
import Foundation
import SwiftUI

/// Contact information for a business card
public struct ContactInformation: Codable {
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
    email != nil || phoneNumber != nil || faxNumber != nil || websiteURL != nil
      || linkedInURL != nil
  }
}

/// Address information for a business card
public struct Address: Codable {
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
    street != nil || city != nil || state != nil || postalCode != nil || country != nil
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
public struct CardStyle: Codable {
  /// Primary color for the card
  public let primaryColor: Color

  /// Secondary color for the card
  public let secondaryColor: Color?

  /// Font name for the card text
  public let fontName: String?

  /// Design style for the card (Modern, Minimal, etc.)
  public let designStyle: CardDesignType

  /// Creates a card style
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

  private enum CodingKeys: String, CodingKey {
    case primaryColorHex, secondaryColorHex, fontName, designStyle
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(primaryColor.toHex, forKey: .primaryColorHex)
    if let secondaryColor = secondaryColor {
      try container.encode(secondaryColor.toHex, forKey: .secondaryColorHex)
    }
    try container.encode(fontName, forKey: .fontName)
    try container.encode(designStyle, forKey: .designStyle)
  }

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

/// Defines the overall design style of a card
public enum CardDesignType: String, Codable {
  case modern
  case minimal
}

/// Represents a business card with professional information and metadata
public struct Card: Identifiable, Codable {
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

  private enum CodingKeys: String, CodingKey {
    case id, name, title, role, company, contactInformation
    case businessAddress, personalAddress, slogan, style
    case collectionDate, latitude, longitude
  }

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
    try container.encode(style, forKey: .style)
    try container.encode(collectionDate, forKey: .collectionDate)
    try container.encode(collectionLocation.latitude, forKey: .latitude)
    try container.encode(collectionLocation.longitude, forKey: .longitude)
  }

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
    style = try container.decode(CardStyle.self, forKey: .style)
    collectionDate = try container.decode(Date.self, forKey: .collectionDate)

    let latitude = try container.decode(Double.self, forKey: .latitude)
    let longitude = try container.decode(Double.self, forKey: .longitude)
    collectionLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

// MARK: - Color Helpers
extension Color {
  /// Initialize a Color from a hex string
  public init?(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0

    Scanner(string: hex).scanHexInt64(&int)

    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:
      (r, g, b, a) = ((int >> 8) & 0xF, (int >> 4) & 0xF, int & 0xF, 0xF)
      self.init(
        .sRGB,
        red: Double(r) / 15,
        green: Double(g) / 15,
        blue: Double(b) / 15,
        opacity: Double(a) / 15
      )
    case 6:
      (r, g, b, a) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF, 0xFF)
      self.init(
        .sRGB,
        red: Double(r) / 255,
        green: Double(g) / 255,
        blue: Double(b) / 255,
        opacity: Double(a) / 255
      )
    case 8:
      (r, g, b, a) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
      self.init(
        .sRGB,
        red: Double(r) / 255,
        green: Double(g) / 255,
        blue: Double(b) / 255,
        opacity: Double(a) / 255
      )
    default:
      return nil
    }
  }

  /// Convert Color to hex string
  var toHex: String {
    let components = UIColor(self).cgColor.components
    let r: CGFloat = components?[0] ?? 0.0
    let g: CGFloat = components?[1] ?? 0.0
    let b: CGFloat = components?[2] ?? 0.0
    let a: CGFloat = components?[3] ?? 0.0

    return String(
      format: "#%02X%02X%02X%02X",
      Int(r * 255),
      Int(g * 255),
      Int(b * 255),
      Int(a * 255)
    )
  }
}
