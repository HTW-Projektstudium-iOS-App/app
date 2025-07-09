import SwiftUI

struct ModernCard: View {
  let card: Card
  let side: CardSide

  let showInfoAction: () -> Void

  var body: some View {
    switch side {
    case .front:
      ModernCardFront(card: card, showInfoAction: showInfoAction)
    case .back:
      ModernCardBack(card: card, showInfoAction: showInfoAction)
    }
  }
}

/// Modern design for front card face
/// Features name, title, and company with left-aligned layout
private struct ModernCardFront: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: CardConstants.Padding.large)

      VStack(alignment: .leading, spacing: CardConstants.Padding.small) {
        Text(card.name)
          .font(CardConstants.Typography.titleFont)
          .bold()
          .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)

        if let title = card.title {
          Text(title)
            .font(CardConstants.Typography.headlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.secondary)
        }

        if let company = card.company {
          Text(company)
            .font(CardConstants.Typography.subheadlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
            .padding(.top, CardConstants.Padding.small / 2)
        }
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardConstants.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardConstants.Padding.standard)
  }
}

/// Modern design for back card face
/// Features contact information, address, and slogan with left-aligned layout
private struct ModernCardBack: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading, spacing: CardConstants.Padding.medium - 2) {
        if let company = card.company {
          Text(company)
            .font(CardConstants.Typography.headlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
        }

        if let role = card.role {
          Text(role)
            .font(CardConstants.Typography.subheadlineFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.secondary)
        }

        if card.contactInformation.hasAnyInformation {
          VStack(alignment: .leading, spacing: CardConstants.Padding.small) {
            if let email = card.contactInformation.email {
              Text(email)
                .font(CardConstants.Typography.footnoteFont)
                .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
            }

            if let phone = card.contactInformation.phoneNumber {
              Text(phone)
                .font(CardConstants.Typography.footnoteFont)
                .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
            }
          }
          .padding(.top, CardConstants.Padding.small)
        }

        if let address = card.businessAddress?.formattedAddress {
          Text(address)
            .font(CardConstants.Typography.footnoteFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
            .padding(.top, CardConstants.Padding.small / 2)
        }

        if let slogan = card.slogan {
          Text("\"\(slogan)\"")
            .font(CardConstants.Typography.captionFont)
            .italic()
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.secondary)
            .padding(.top, CardConstants.Padding.small)
        }
      }

      Spacer()

      HStack {
        Spacer()
        Button(action: showInfoAction) {
          Image(systemName: "info.circle")
            .font(CardConstants.Typography.titleFont)
            .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(CardConstants.Padding.standard)
  }
}
