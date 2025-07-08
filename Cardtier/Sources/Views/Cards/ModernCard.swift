import SwiftUI

/// Modern design for front card face
/// Features name, title, and company with left-aligned layout
struct ModernCardFront: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: CardDesign.Padding.large)

      VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
        Text(card.name)
          .font(CardDesign.Typography.titleFont)
          .bold()
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

        if let title = card.title {
          Text(title)
            .font(CardDesign.Typography.headlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
        }

        if let company = card.company {
          Text(company)
            .font(CardDesign.Typography.subheadlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            .padding(.top, CardDesign.Padding.small / 2)
        }
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardDesign.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardDesign.Padding.standard)
  }
}

/// Modern design for back card face
/// Features contact information, address, and slogan with left-aligned layout
struct ModernCardBack: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
        if let company = card.company {
          Text(company)
            .font(CardDesign.Typography.headlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }

        if let role = card.role {
          Text(role)
            .font(CardDesign.Typography.subheadlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
        }

        if card.contactInformation.hasAnyInformation {
          VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
            if let email = card.contactInformation.email {
              Text(email)
                .font(CardDesign.Typography.footnoteFont)
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }

            if let phone = card.contactInformation.phoneNumber {
              Text(phone)
                .font(CardDesign.Typography.footnoteFont)
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }
          }
          .padding(.top, CardDesign.Padding.small)
        }

        if let address = card.businessAddress?.formattedAddress {
          Text(address)
            .font(CardDesign.Typography.footnoteFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            .padding(.top, CardDesign.Padding.small / 2)
        }

        if let slogan = card.slogan {
          Text("\"\(slogan)\"")
            .font(CardDesign.Typography.captionFont)
            .italic()
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
            .padding(.top, CardDesign.Padding.small)
        }
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardDesign.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardDesign.Padding.standard)
  }
}
