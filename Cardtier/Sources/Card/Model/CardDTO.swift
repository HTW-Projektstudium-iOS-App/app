import Foundation

/// Data transfer object for a business card
struct CardDTO: Codable {
  var id: UUID
  var name: String
  var title: String?
  var company: String?
  var contactInformation: Card.ContactInformation
  var businessAddress: Card.Address?
  var personalAddress: Card.Address?
  var slogan: String?
  var logos: [Data]
  var style: Card.CardStyle

  /// Creates a data transfer object from a business card
  init(
    from card: Card
  ) {
    self.id = card.id
    self.name = card.name
    self.title = card.title
    self.company = card.company
    self.contactInformation = card.contactInformation
    self.businessAddress = card.businessAddress
    self.personalAddress = card.personalAddress
    self.slogan = card.slogan
    self.logos = card.logos
    self.style = card.style
  }

  /// Creates a business card from a data transfer object
  /// TODO: get collection location from user physical location
  func createCard() -> Card {
    Card(
      id: id,
      isUserCard: false,
      name: name,
      title: title,
      company: company,
      contactInformation: contactInformation,
      businessAddress: businessAddress,
      personalAddress: personalAddress,
      slogan: slogan,
      logos: logos,
      style: style
    )
  }
}
