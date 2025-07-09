import CoreLocation
import Foundation
import SwiftUI

/// Represents a business card with professional information and metadata
struct Card: Identifiable, Codable {
  /// Unique identifier for the card
  let id: UUID

  /// Full name of the person
  let name: String

  /// Professional title (e.g., "CEO")
  let title: String?

  /// Role or position (e.g., "Executive Management")
  let role: String?

  /// Company or organization name
  let company: String?

  /// Contact information (email, phone, etc.)
  let contactInformation: ContactInformation

  /// Business/company address
  let businessAddress: Address?

  /// Personal/private address
  let personalAddress: Address?

  /// Company slogan or tagline
  let slogan: String?

  /// Array of logos or images to display
  let logos: [UIImage]?

  /// Visual styling for the card
  let style: CardStyle

  /// Date when the card was collected
  let collectionDate: Date

  private let collectionLatitude: Double
  private let collectionLongitude: Double

  /// Geographic location where the card was collected
  var collectionLocation: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: collectionLatitude, longitude: collectionLongitude)
  }

  /// Creates a new business card with full details
  init(
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
    self.collectionLatitude = collectionLocation.latitude
    self.collectionLongitude = collectionLocation.longitude
  }

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
    collectionLatitude = try container.decode(Double.self, forKey: .latitude)
    collectionLongitude = try container.decode(Double.self, forKey: .longitude)
  }
}
