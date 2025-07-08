import SwiftUI

/// Minimal design for front card face
/// Simplified, centered layout with just name and title
struct MinimalCardFront: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Spacer()

      Text(card.name)
        .font(CardDesign.Typography.titleFont)
        .bold()
        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

      if let title = card.title {
        Text(title)
          .font(CardDesign.Typography.subheadlineFont)
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
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

struct MinimalCardBack: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Spacer()

      if let company = card.company {
        Text(company)
          .font(CardDesign.Typography.headlineFont)
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
      }

      if let email = card.contactInformation.email {
        Text(email)
          .font(CardDesign.Typography.captionFont)
          .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
          .padding(.top, CardDesign.Padding.small)
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
