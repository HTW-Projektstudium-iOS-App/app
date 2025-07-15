import Foundation

extension Card {
  /// Contact information for a business card
  struct ContactInformation: Codable {
    /// Email address
    let email: String?

    /// Phone number
    let phoneNumber: String?

    /// Fax number
    let faxNumber: String?

    /// Website URL
    let websiteURL: String?

    /// LinkedIn profile URL
    let linkedInURL: String?

    /// Creates contact information with optional fields
    init(
      email: String? = nil,
      phoneNumber: String? = nil,
      faxNumber: String? = nil,
      websiteURL: String? = nil,
      linkedInURL: String? = nil
    ) {
      self.email = email
      self.phoneNumber = phoneNumber
      self.faxNumber = faxNumber
      self.websiteURL = websiteURL
      self.linkedInURL = linkedInURL
    }

    /// Check if any contact information is available
    var hasAnyInformation: Bool {
      email != nil || phoneNumber != nil || faxNumber != nil || websiteURL != nil
        || linkedInURL != nil
    }
  }
}
