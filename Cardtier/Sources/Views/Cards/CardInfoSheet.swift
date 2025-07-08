import SwiftUI

/// Sheet displaying detailed metadata about a business card
/// Appears when user taps info button
struct CardInfoSheet: View {
  /// The card to display information for
  let card: Card

  /// Binding to control sheet presentation
  @Binding var isPresented: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: CardDesign.Padding.large) {
      Text(card.name)
        .font(CardDesign.Typography.headlineFont)
        .foregroundColor(CardDesign.Colors.primary)

      if card.contactInformation.hasAnyInformation {
        Group {
          Text("Contact Information")
            .font(CardDesign.Typography.subheadlineFont)
            .bold()
            .foregroundColor(CardDesign.Colors.primary)

          VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
            if let email = card.contactInformation.email {
              Text("Email: \(email)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let phone = card.contactInformation.phoneNumber {
              Text("Phone: \(phone)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let fax = card.contactInformation.faxNumber {
              Text("Fax: \(fax)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let website = card.contactInformation.websiteURL {
              Text("Website: \(website.absoluteString)")
                .foregroundColor(CardDesign.Colors.primary)
            }
            if let linkedin = card.contactInformation.linkedInURL {
              Text("LinkedIn: \(linkedin.absoluteString)")
                .foregroundColor(CardDesign.Colors.primary)
            }
          }
          Divider()
        }
      }

      if let address = card.businessAddress, address.hasAnyInformation {
        Group {
          Text("Business Address")
            .font(CardDesign.Typography.subheadlineFont)
            .bold()
            .foregroundColor(CardDesign.Colors.primary)

          Text(address.formattedAddress ?? "")
            .foregroundColor(CardDesign.Colors.primary)

          Divider()
        }
      }

      Group {
        Text("Collection Data")
          .font(CardDesign.Typography.subheadlineFont)
          .bold()
          .foregroundColor(CardDesign.Colors.primary)

        Text("Date: \(card.collectionDate.formatted(date: .long, time: .shortened))")
          .foregroundColor(CardDesign.Colors.primary)

        Text(
          """
          Location: \
          \(card.collectionLocation.latitude, specifier: "%.4f"), \
          \(card.collectionLocation.longitude, specifier: "%.4f")
          """
        )
        .foregroundColor(CardDesign.Colors.primary)
      }

      Spacer()

      Button("Close") {
        isPresented = false
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, CardDesign.Padding.medium)
      .background(CardDesign.Colors.accent)
      .foregroundColor(.white)
      .cornerRadius(8)
    }
    .padding(CardDesign.Padding.standard)
    .background(Color(.systemBackground))
  }
}
