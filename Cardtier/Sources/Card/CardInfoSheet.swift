import SwiftUI

/// Sheet displaying detailed metadata about a business card
/// Appears when user taps info button
struct CardInfoSheet: View {
  /// The card to display information for
  let card: Card

  /// Binding to control sheet presentation
  @Binding var isPresented: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: CardConstants.Padding.large) {
      Text(card.name)
        .font(CardConstants.Typography.headlineFont)
        .foregroundColor(CardConstants.Colors.primary)

      if card.contactInformation.hasAnyInformation {
        Group {
          Text("Contact Information")
            .font(CardConstants.Typography.subheadlineFont)
            .bold()
            .foregroundColor(CardConstants.Colors.primary)

          VStack(alignment: .leading, spacing: CardConstants.Padding.medium - 2) {
            if let email = card.contactInformation.email {
              Text("Email: \(email)")
                .foregroundColor(CardConstants.Colors.primary)
            }
            if let phone = card.contactInformation.phoneNumber {
              Text("Phone: \(phone)")
                .foregroundColor(CardConstants.Colors.primary)
            }
            if let fax = card.contactInformation.faxNumber {
              Text("Fax: \(fax)")
                .foregroundColor(CardConstants.Colors.primary)
            }
            if let website = card.contactInformation.websiteURL {
              Text("Website: \(website.absoluteString)")
                .foregroundColor(CardConstants.Colors.primary)
            }
            if let linkedin = card.contactInformation.linkedInURL {
              Text("LinkedIn: \(linkedin.absoluteString)")
                .foregroundColor(CardConstants.Colors.primary)
            }
          }
          Divider()
        }
      }

      if let address = card.businessAddress, address.hasAnyInformation {
        Group {
          Text("Business Address")
            .font(CardConstants.Typography.subheadlineFont)
            .bold()
            .foregroundColor(CardConstants.Colors.primary)

          Text(address.formattedAddress ?? "")
            .foregroundColor(CardConstants.Colors.primary)

          Divider()
        }
      }

      Group {
        Text("Collection Data")
          .font(CardConstants.Typography.subheadlineFont)
          .bold()
          .foregroundColor(CardConstants.Colors.primary)

        Text("Date: \(card.collectionDate.formatted(date: .long, time: .shortened))")
          .foregroundColor(CardConstants.Colors.primary)

        Text(
          """
          Location: \
          \(card.collectionLocation.latitude, specifier: "%.4f"), \
          \(card.collectionLocation.longitude, specifier: "%.4f")
          """
        )
        .foregroundColor(CardConstants.Colors.primary)
      }

      Spacer()

      Button("Close") {
        isPresented = false
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, CardConstants.Padding.medium)
      .background(CardConstants.Colors.accent)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .padding(CardConstants.Padding.standard)
    .background(Color(.systemBackground))
  }
}
