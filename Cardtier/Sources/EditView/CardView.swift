import SwiftUI

struct CardView: View {
  let data: CardData
  let cardType: CardType

  let test = [
    "test"
  ]

  enum CardType {
    case front, back
  }

  var body: some View {
    Rectangle()
      .fill(
        cardType == .front
          ? data.backgroundColorFront
          : data.backgroundColorBack
      )
      .overlay(
        VStack {
          if cardType == .front {
            Text(data.name)
              .font(.title2.bold())
              .foregroundColor(data.textColorFront)
            Text(data.title)
              .font(.subheadline)
              .foregroundColor(data.textColorFront)
            Text(data.company)
              .font(.caption)
              .foregroundColor(data.textColorFront)
          } else {
            Text(data.email)
              .font(.body)
              .foregroundColor(data.textColorBack)
            Text(data.phone)
              .font(.body)
              .foregroundColor(data.textColorBack)
            Text(data.website)
              .font(.body)
              .foregroundColor(data.textColorBack)
          }
        }
      )
      .cornerRadius(12)
  }
}

struct CardData {
  var name: String = "John Doe"
  var title: String = "Software Engineer"
  var company: String = "Tech Corp"
  var email: String = "john@example.com"
  var phone: String = "+1 234 567 8900"
  var website: String = "johndoe.com"

  var backgroundColorFront: Color = .blue
  var textColorFront: Color = .white
  var fontSizeFront: Double = 16

  var backgroundColorBack: Color = .gray
  var textColorBack: Color = .black
  var fontSizeBack: Double = 14
}
