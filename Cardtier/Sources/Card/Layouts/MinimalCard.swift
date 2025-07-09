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
    ZStack {
      Rectangle()
        .fill(card.style.primaryColor)
        .overlay(
          Rectangle()
            .stroke((card.style.secondaryColor ?? Color.black).opacity(0.2), lineWidth: 0.5)
        )

      Text(getMonogramInitials())
        .font(.custom("Zapfino", size: 60).weight(.thin))
        .foregroundColor(Color.gray.opacity(0.25))
        .offset(y: 10)
        .padding(0)

      VStack(spacing: 2) {
        Text(card.name)
          .font(CardElements.customFont(name: card.style.fontName, size: 18, weight: .medium))
          .foregroundColor(card.style.secondaryColor ?? .black)

        if let role = card.role {
          Text(role)
            .font(CardElements.customFont(name: card.style.fontName, size: 16))
            .foregroundColor(card.style.secondaryColor ?? .black)
        }
      }
      .padding(0)

      VStack {
        Spacer()
        HStack {
          Spacer()
          CardElements.infoButton(card: card, action: showInfoAction)
            .padding([.bottom, .trailing], 4)
        }
      }
    }
    .frame(maxHeight: .infinity)
    .clipShape(Rectangle())
  }

  /// Returns initials for the monogram (first and last name, or fallback)
  private func getMonogramInitials() -> String {
    let nameParts = card.name.components(separatedBy: " ")
    if nameParts.count >= 2 {
      let firstInitial = nameParts[0].prefix(1)
      let lastInitial = nameParts[1].prefix(1)
      return "\(firstInitial)\(lastInitial)"
    } else if let initial = nameParts.first?.prefix(1) {
      return String(initial)
    }
    return "VN"
  }
}

struct MinimalCardBack: View {
  let card: Card
  let showInfoAction: () -> Void

  var body: some View {
    ZStack {
      Rectangle()
        .fill(card.style.primaryColor)
        .overlay {
          Rectangle()
            .stroke((card.style.secondaryColor ?? Color.black).opacity(0.2), lineWidth: 0.5)
        }

      VStack {
        if let company = card.company {
          Text(company.uppercased())
            .font(CardElements.customFont(name: card.style.fontName, size: 14, weight: .bold))
            .foregroundColor(card.style.secondaryColor ?? .black)
            .padding(.top, 80)
        }

        Spacer()

        VStack(spacing: 0) {
          HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .center, spacing: 8) {
              HStack(spacing: 5) {
                socialIcon(text: "in")
                socialIcon(text: "ig")
                socialIcon(text: "X")
                socialIcon(text: "OF")
              }
              Text("@username")
                .font(CardElements.customFont(name: card.style.fontName, size: 12))
                .foregroundColor(card.style.secondaryColor ?? .black)
            }

            Rectangle()
              .fill(card.style.secondaryColor ?? .black)
              .frame(width: 1, height: 50)

            VStack(alignment: .leading, spacing: 5) {
              contactItem(
                text: card.contactInformation.websiteURL?.absoluteString ?? "www.website.com")
              contactItem(text: card.contactInformation.email ?? "company@email.com")
              contactItem(text: card.contactInformation.phoneNumber ?? "1076-14734920")
            }
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 20)
        }
      }

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

  /// Social icon in a gray circle with label (keeps original color)
  private func socialIcon(text: String) -> some View {
    ZStack {
      Circle()
        .fill(Color.gray.opacity(0.5))
        .frame(width: 28, height: 28)

      Text(text)
        .font(CardElements.customFont(name: card.style.fontName, size: 11))
        .foregroundColor(.white)
    }
  }

  /// Contact info item, styled
  private func contactItem(text: String) -> some View {
    Text(text)
      .font(CardElements.customFont(name: card.style.fontName, size: 12))
      .foregroundColor(card.style.secondaryColor ?? .black)
  }
}
