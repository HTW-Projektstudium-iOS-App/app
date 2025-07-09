extension Card {
  /// Address information for a business card
  struct Address: Codable {
    /// Street name and number
    let street: String?

    /// City name
    let city: String?

    /// State or province
    let state: String?

    /// Postal or ZIP code
    let postalCode: String?

    /// Country
    let country: String?

    /// Creates address information with optional fields
    init(
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
    var hasAnyInformation: Bool {
      street != nil || city != nil || state != nil || postalCode != nil || country != nil
    }

    /// Returns a formatted, multi-line address string
    var formattedAddress: String? {
      let cityStatePostal = "\(city ?? "")\(state != nil ? ", \(state!)" : "") \(postalCode ?? "")"

      return [
        street ?? "",
        cityStatePostal,
        country ?? "",
      ]
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty }
      .joined(separator: "\n")
    }
  }
}
