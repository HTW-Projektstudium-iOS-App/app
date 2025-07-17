import Contacts
import Foundation
import UIKit

/// Saves a business card into the iOS Contacts app
struct ContactService {
  let store = CNContactStore()

  // swiftlint:disable:next function_body_length cyclomatic_complexity
  func save(card: Card, completion: @escaping (Result<Void, Error>) -> Void) {
    // Request permission to access Contacts.
    store.requestAccess(for: .contacts) { granted, error in
      if let error = error {
        DispatchQueue.main.async { completion(.failure(error)) }
        return
      }

      guard granted else {
        let authError = NSError(
          domain: "ContactAccess",
          code: 1,
          userInfo: [NSLocalizedDescriptionKey: "Contacts access was denied."]
        )
        DispatchQueue.main.async { completion(.failure(authError)) }
        return
      }

      // Create a mutable contact and fill in the fields.
      let contact = CNMutableContact()

      // Full name
      let parts = card.name.split(separator: " ", maxSplits: 1).map(String.init)
      contact.givenName = parts.first ?? ""
      contact.familyName = parts.count > 1 ? parts.last! : ""

      // Company and job title
      if let company = card.company {
        contact.organizationName = company
      }
      if let title = card.title {
        contact.jobTitle = title
      }

      // Phone number
      if let phone = card.contactInformation.phoneNumber {
        let phoneValue = CNPhoneNumber(stringValue: phone)
        let labeledPhone = CNLabeledValue(
          label: CNLabelPhoneNumberMobile,
          value: phoneValue
        )
        contact.phoneNumbers = [labeledPhone]
      }

      // Email address
      if let email = card.contactInformation.email {
        let labeledEmail = CNLabeledValue(
          label: CNLabelWork,
          value: email as NSString
        )
        contact.emailAddresses = [labeledEmail]
      }

      // Website URL
      if let website = card.contactInformation.websiteURL,
        !website.isEmpty
      {
        let labeledURL = CNLabeledValue(
          label: CNLabelURLAddressHomePage,
          value: website as NSString
        )
        contact.urlAddresses = [labeledURL]
      }

      // LinkedIn profile
      if let linkedIn = card.contactInformation.linkedInURL,
        !linkedIn.isEmpty
      {
        let socialProfile = CNSocialProfile(
          urlString: linkedIn,
          username: nil,
          userIdentifier: nil,
          service: CNSocialProfileServiceLinkedIn
        )
        let labeledProfile = CNLabeledValue(
          label: CNSocialProfileServiceLinkedIn,
          value: socialProfile
        )
        contact.socialProfiles.append(labeledProfile)
      }

      // Business address
      if let business = card.businessAddress {
        let postal = CNMutablePostalAddress()
        postal.street = business.street ?? ""
        postal.city = business.city ?? ""
        postal.state = business.state ?? ""
        postal.postalCode = business.postalCode ?? ""
        postal.country = business.country ?? ""

        if let immutablePostal = postal.copy() as? CNPostalAddress {
          let labeledPostal = CNLabeledValue(
            label: CNLabelWork,
            value: immutablePostal
          )
          contact.postalAddresses.append(labeledPostal)
        }
      }

      // Create a save request and add the contact.
      let saveRequest = CNSaveRequest()
      saveRequest.add(contact, toContainerWithIdentifier: nil)

      // Execute the save request.
      do {
        try store.execute(saveRequest)
        DispatchQueue.main.async { completion(.success(())) }
      } catch {
        DispatchQueue.main.async { completion(.failure(error)) }
      }
    }
  }
}
