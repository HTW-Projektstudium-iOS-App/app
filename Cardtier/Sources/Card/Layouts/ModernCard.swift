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
    ZStack {
      // Background
      Rectangle()
        .fill(card.style.primaryColor)

      // Logo in the absolute top left corner
      VStack {
        HStack {
          CardElements.logo(
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .circle,
            width: 30,
            height: 30,
            contentWidth: 25,
            contentHeight: 25
          )
          .padding([.top, .leading], 4)
          Spacer()
        }
        Spacer()
      }

      // "Global Industries | Research" in the top right, vertically centered to logo
      VStack {
        HStack {
          Spacer()
          if let company = card.company, let title = card.title {
            Text("\(company) | \(title)")
              .font(CardElements.customFont(name: card.style.fontName, size: 12))
              .foregroundColor(card.style.secondaryColor ?? .black)
              .padding(.top, 17)
              .padding(.trailing, 4)
          }
        }
        Spacer()
      }

      // Main content
      VStack(alignment: .leading, spacing: 4) {
        Spacer()
          .frame(height: 60)

        // Name
        Text(card.name.uppercased())
          .font(CardElements.customFont(name: card.style.fontName, size: 28, weight: .black))
          .foregroundColor(card.style.secondaryColor ?? .black)
          .padding(.top, 4)

        // Contact information
        HStack(alignment: .top, spacing: 8) {
          CardElements.logo(
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .square,
            width: 70,
            height: 70,
            contentWidth: 60,
            contentHeight: 60
          )

          VStack(alignment: .leading, spacing: 4) {
            contactItem(label: "Email:", value: card.contactInformation.email)
            contactItem(label: "Handynummer:", value: card.contactInformation.phoneNumber)
          }

          Spacer()

          VStack(alignment: .leading, spacing: 4) {
            contactItem(
              label: "Website:", value: card.contactInformation.websiteURL)
            contactItem(label: "LinkedIN:", value: card.contactInformation.linkedInURL)
          }
        }

        // Slogan bullets
        if let slogan = card.slogan {
          Spacer()
          VStack(alignment: .leading, spacing: 2) {
            ForEach(slogan.components(separatedBy: " - "), id: \.self) { item in
              HStack(alignment: .top, spacing: 8) {
                Text("•")
                  .font(CardElements.customFont(name: card.style.fontName, size: 10))
                Text(item)
                  .font(CardElements.customFont(name: card.style.fontName, size: 10))
              }
              .foregroundColor(card.style.secondaryColor ?? .black)
            }
          }
        }
      }
      .padding(4)

      // Info button in the absolute bottom right corner
      VStack {
        Spacer()
        HStack {
          Spacer()
          CardElements.infoButton(card: card, action: showInfoAction)
            .padding([.bottom, .trailing], 4)
        }
      }
    }
  }

  private func contactItem(label: String, value: String?) -> some View {
    Group {
      if let value = value {
        VStack(alignment: .leading, spacing: 0) {
          Text(label)
            .font(CardElements.customFont(name: card.style.fontName, size: 10, weight: .bold))
          Text(value)
            .font(CardElements.customFont(name: card.style.fontName, size: 10))
        }
        .foregroundColor(
          card.style.secondaryColor ?? .black
        )
      }
    }
  }
}

/// Modern design for back card face
/// Features contact information, address, and slogan with left-aligned layout
private struct ModernCardBack: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    ZStack {
      Rectangle().fill(card.style.primaryColor)

      VStack {
        Spacer()

        HStack(spacing: 10) {
          CardElements.logo(
            index: 0,
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .circle,
            width: 45,
            height: 45,
            contentWidth: 35,
            contentHeight: 35
          )

          // Medium logo (left)
          CardElements.logo(
            index: 1,
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .circle,
            width: 55,
            height: 55,
            contentWidth: 45,
            contentHeight: 45
          )

          // Large logo (center)
          CardElements.logo(
            index: 2,
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .circle,
            width: 65,
            height: 65,
            contentWidth: 55,
            contentHeight: 55
          )

          // Medium logo (right)
          CardElements.logo(
            index: 3,
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .circle,
            width: 55,
            height: 55,
            contentWidth: 45,
            contentHeight: 45
          )

          // Smaller logo (right)
          CardElements.logo(
            index: 4,
            logos: card.logos,
            color: card.style.secondaryColor,
            shape: .circle,
            width: 45,
            height: 45,
            contentWidth: 35,
            contentHeight: 35
          )
        }
        .frame(maxWidth: .infinity, alignment: .center)

        Spacer()

        // Info button
        HStack {
          Spacer()
          CardElements.infoButton(card: card, action: showInfoAction)
        }
      }
      .padding(4)
    }
  }
}
