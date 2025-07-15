import SwiftUI

struct TraditionalCard: View {
  let card: Card
  let side: CardSide

  var body: some View {
    switch side {
    case .front:
      TraditionalCardFront(card: card)
    case .back:
      TraditionalCardBack(card: card)
    }
  }
}

struct TraditionalCardFront: View {
  let card: Card

  var body: some View {
    ZStack {
      VStack {
        // Top right: company, role, logo
        HStack(alignment: .top) {
          Spacer()
          VStack(alignment: .trailing) {
            HStack {
              if let company = card.company {
                Text(company)
                  .font(CardElements.customFont(name: card.style.fontName, size: 12))
                  .foregroundColor(card.style.secondaryColor ?? .black)
              }
              if let title = card.title {
                Text("| \(title)")
                  .font(CardElements.customFont(name: card.style.fontName, size: 12))
                  .foregroundColor(card.style.secondaryColor ?? .black)
              }
            }
            // Logo (first logo from the array)
            CardElements.logo(
              logos: card.logos,
              color: card.style.secondaryColor,
              shape: .oval,
              width: 95,
              height: 50,
              contentWidth: 85,
              contentHeight: 40
            )
          }
        }

        Spacer()

        // Name (large, bottom left)
        Text(card.name)
          .font(CardElements.customFont(name: card.style.fontName, size: 32, weight: .black))
          .foregroundColor(card.style.secondaryColor ?? .black)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 0)
      }
      .padding(16)
    }
  }
}

struct TraditionalCardBack: View {
  let card: Card

  var body: some View {
    ZStack {
      VStack {
        // Website URL at top right
        HStack {
          Spacer()
          if let website = card.contactInformation.websiteURL {
            Text(website)
              .font(CardElements.customFont(name: card.style.fontName, size: 12))
              .foregroundColor(card.style.secondaryColor ?? .black)
              .italic()
          }
        }
        .padding([.top, .horizontal], 16)

        Spacer()

        // Three logos (centered, stacked)
        VStack(spacing: -10) {
          HStack(spacing: 50) {
            CardElements.logo(
              index: 0,
              logos: card.logos,
              color: card.style.secondaryColor,
              shape: .oval,
              width: 95,
              height: 50,
              contentWidth: 85,
              contentHeight: 40
            )
            CardElements.logo(
              index: 1,
              logos: card.logos,
              color: card.style.secondaryColor,
              shape: .oval,
              width: 95,
              height: 50,
              contentWidth: 85,
              contentHeight: 40
            )
          }
          CardElements.logo(
            index: 2,
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .oval,
            width: 95,
            height: 50,
            contentWidth: 85,
            contentHeight: 40
          )
        }

        Spacer()

        // Contact information (bottom right)
        VStack(alignment: .trailing, spacing: 4) {
          if let phone = card.contactInformation.phoneNumber {
            Text(phone)
              .font(CardElements.customFont(name: card.style.fontName, size: 12))
              .foregroundColor(card.style.secondaryColor ?? .black)
              .italic()
          }
          if let linkedIn = card.contactInformation.linkedInURL {
            Text(linkedIn)
              .font(CardElements.customFont(name: card.style.fontName, size: 12))
              .foregroundColor(card.style.secondaryColor ?? .black)
              .italic()
          }
          if let email = card.contactInformation.email {
            Text(email)
              .font(CardElements.customFont(name: card.style.fontName, size: 12))
              .foregroundColor(card.style.secondaryColor ?? .black)
              .italic()
          }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding([.bottom, .horizontal], 16)
      }
    }
  }
}
