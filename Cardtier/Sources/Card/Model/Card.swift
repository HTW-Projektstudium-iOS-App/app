import CoreLocation
import Foundation
import SwiftData
import SwiftUI

/// Represents a business card with professional information and metadata
@Model class Card: Identifiable {
  /// Unique identifier for the card
  var id: UUID

  /// Indicates whether it's the users own card or a card collected by the user
  var isUserCard: Bool

  /// Full name of the person
  var name: String

  /// Professional title (e.g., "CEO")
  var title: String?

  /// Role or position (e.g., "Executive Management")
  var role: String?

  /// Company or organization name
  var company: String?

  /// Contact information (email, phone, etc.)
  var contactInformation: ContactInformation

  /// Business/company address
  var businessAddress: Address?

  /// Personal/private address
  var personalAddress: Address?

  /// Company slogan or tagline
  var slogan: String?

  /// Array of logos or images to display
  var logos: [Data]?

  /// Visual styling for the card
  var style: CardStyle

  /// Date when the card was collected
  var collectionDate: Date

  private var collectionLatitude: Double
  private var collectionLongitude: Double

  /// Geographic location where the card was collected
  var collectionLocation: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: collectionLatitude, longitude: collectionLongitude)
  }

  /// Creates a new business card with full details
  init(
    id: UUID = UUID(),
    isUserCard: Bool = true,
    name: String,
    title: String? = nil,
    role: String? = nil,
    company: String? = nil,
    contactInformation: ContactInformation = ContactInformation(),
    businessAddress: Address? = nil,
    personalAddress: Address? = nil,
    slogan: String? = nil,
    logos: [Data]? = nil,
    style: CardStyle = CardStyle(),
    collectionDate: Date = Date(),
    collectionLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
  ) {
    self.id = id
    self.name = name
    self.isUserCard = isUserCard
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
}
