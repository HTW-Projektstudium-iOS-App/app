import SwiftUI

struct MinimalCard: View {
  let card: Card
  let side: CardSide

  let showInfoAction: () -> Void

  var body: some View {
    switch side {
    case .front:
      MinimalCardFront(card: card, showInfoAction: showInfoAction)
    case .back:
      MinimalCardBack(card: card, showInfoAction: showInfoAction)
    }
  }
}

/// Minimal design for front card face
/// Simplified, centered layout with just name and title
struct MinimalCardFront: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Spacer()

      Text(card.name)
        .font(CardConstants.Typography.titleFont)
        .bold()
        .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)

      if let title = card.title {
        Text(title)
          .font(CardConstants.Typography.subheadlineFont)
          .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.secondary)
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

struct MinimalCardBack: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    VStack(alignment: .center) {
      Spacer()

      if let company = card.company {
        Text(company)
          .font(CardConstants.Typography.headlineFont)
          .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.primary)
      }

      if let email = card.contactInformation.email {
        Text(email)
          .font(CardConstants.Typography.captionFont)
          .foregroundColor(card.style.secondaryColor ?? CardConstants.Colors.secondary)
          .padding(.top, CardConstants.Padding.small)
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
