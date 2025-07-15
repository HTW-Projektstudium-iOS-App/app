import CoreLocation
import Foundation
import SwiftUI

@Observable
// TODO: do we actually need this instead of just using the model?
class CardDraft {
  var id: UUID = UUID()
  var name: String = ""
  var title: String = ""
  var company: String = ""

  var contactInformation: ContactInformation = ContactInformation()

  var businessAddress: Address = Address()
  var personalAddress: Address = Address()

  var slogan: String = ""
  var logos: [Data] = []
  var style: CardStyle = CardStyle()

  init() {}

  init(from card: Card) {
    id = card.id
    name = card.name
    title = card.title ?? ""
    company = card.company ?? ""

    contactInformation = ContactInformation(
      email: card.contactInformation.email ?? "",
      phoneNumber: card.contactInformation.phoneNumber ?? "",
      faxNumber: card.contactInformation.faxNumber ?? "",
      websiteURL: card.contactInformation.websiteURL ?? "",
      linkedInURL: card.contactInformation.linkedInURL ?? ""
    )

    businessAddress = Address(
      street: card.businessAddress?.street ?? "",
      city: card.businessAddress?.city ?? "",
      state: card.businessAddress?.state ?? "",
      postalCode: card.businessAddress?.postalCode ?? "",
      country: card.businessAddress?.country ?? ""
    )

    personalAddress = Address(
      street: card.personalAddress?.street ?? "",
      city: card.personalAddress?.city ?? "",
      state: card.personalAddress?.state ?? "",
      postalCode: card.personalAddress?.postalCode ?? "",
      country: card.personalAddress?.country ?? ""
    )

    slogan = card.slogan ?? ""

    logos = card.logos

    style = CardStyle(
      primaryColor: card.style.primaryColor,
      secondaryColor: card.style.secondaryColor ?? .black,
      fontName: card.style.fontName,
      designStyle: card.style.designStyle
    )
  }

  func apply(to card: Card) {
    card.id = id
    card.name = name
    card.title = title
    card.company = company

    card.contactInformation = Card.ContactInformation(
      email: contactInformation.email,
      phoneNumber: contactInformation.phoneNumber,
      faxNumber: contactInformation.faxNumber,
      websiteURL: contactInformation.websiteURL,
      linkedInURL: contactInformation.linkedInURL
    )

    card.businessAddress = Card.Address(
      street: businessAddress.street,
      city: businessAddress.city,
      state: businessAddress.state,
      postalCode: businessAddress.postalCode,
      country: businessAddress.country
    )

    card.personalAddress = Card.Address(
      street: personalAddress.street,
      city: personalAddress.city,
      state: personalAddress.state,
      postalCode: personalAddress.postalCode,
      country: personalAddress.country
    )

    card.slogan = slogan
    card.logos = logos

    card.style = Card.CardStyle(
      primaryColor: style.primaryColor,
      secondaryColor: style.secondaryColor,
      fontName: style.fontName,
      designStyle: style.designStyle
    )
  }

  func createCard() -> Card {
    Card(
      id: id,
      name: name,
      title: title,
      company: company,
      contactInformation: Card.ContactInformation(
        email: contactInformation.email,
        phoneNumber: contactInformation.phoneNumber,
        faxNumber: contactInformation.faxNumber,
        websiteURL: contactInformation.websiteURL,
        linkedInURL: contactInformation.linkedInURL
      ),
      businessAddress: Card.Address(
        street: businessAddress.street,
        city: businessAddress.city,
        state: businessAddress.state,
        postalCode: businessAddress.postalCode,
        country: businessAddress.country
      ),
      personalAddress: Card.Address(
        street: personalAddress.street,
        city: personalAddress.city,
        state: personalAddress.state,
        postalCode: personalAddress.postalCode,
        country: personalAddress.country
      ),
      slogan: slogan,
      logos: logos,
      style: Card.CardStyle(
        primaryColor: style.primaryColor,
        secondaryColor: style.secondaryColor,
        fontName: style.fontName,
        designStyle: style.designStyle
      ),
    )
  }

  @Observable
  class ContactInformation {
    var email: String
    var phoneNumber: String
    var faxNumber: String
    var websiteURL: String
    var linkedInURL: String

    init(
      email: String = "",
      phoneNumber: String = "",
      faxNumber: String = "",
      websiteURL: String = "",
      linkedInURL: String = ""
    ) {
      self.email = email
      self.phoneNumber = phoneNumber
      self.faxNumber = faxNumber
      self.websiteURL = websiteURL
      self.linkedInURL = linkedInURL
    }
  }

  @Observable
  class Address {
    var street: String
    var city: String
    var state: String
    var postalCode: String
    var country: String

    init(
      street: String = "",
      city: String = "",
      state: String = "",
      postalCode: String = "",
      country: String = ""
    ) {
      self.street = street
      self.city = city
      self.state = state
      self.postalCode = postalCode
      self.country = country
    }
  }

  @Observable
  class CardStyle {
    var test: String = "test"
    var primaryColor: Color
    var secondaryColor: Color
    var fontName: String
    var designStyle: Card.DesignType

    init(
      primaryColor: Color = .white,
      secondaryColor: Color = .black,
      fontName: String = "Courier New",
      designStyle: Card.DesignType = .modern
    ) {
      self.primaryColor = primaryColor
      self.secondaryColor = secondaryColor
      self.fontName = fontName
      self.designStyle = designStyle
    }
  }
}
