import CoreLocation
import Foundation

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

  private let collectionLatitude: Double
  private let collectionLongitude: Double

  /// Geographic location where the card was collected
  public var collectionLocation: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: collectionLatitude, longitude: collectionLongitude)
  }

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
    self.collectionLatitude = collectionLocation.latitude
    self.collectionLongitude = collectionLocation.longitude
  }
}
