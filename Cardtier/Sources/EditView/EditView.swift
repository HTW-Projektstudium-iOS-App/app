import SwiftUI

public struct EditView: View {
  @State private var activeCardIndex: Int? = 0
  @State private var cardData = CardData()

  public var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 20) {
            CardView(data: cardData, cardType: .front)
              .aspectRatio(545 / 340, contentMode: .fit)
              .frame(width: geometry.size.width * 0.85)
              .id(0)

            CardView(data: cardData, cardType: .back)
              .aspectRatio(545 / 340, contentMode: .fit)
              .frame(width: geometry.size.width * 0.85)
              .id(1)
          }
          .scrollTargetLayout()
          .padding(.horizontal, geometry.size.width * 0.075)
        }
        .padding(.vertical)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $activeCardIndex)

        VStack {
          HStack {
            Text(activeCardIndex == 0 ? "Front Side" : "Back Side")
              .font(.headline)
              .foregroundColor(.primary)
          }
          .padding(.horizontal)
          .padding(.top)

          Form {
            if activeCardIndex == 0 {
              Section(header: Text("Personal Information")) {
                TextField("Name", text: $cardData.name)
                TextField("Title", text: $cardData.title)
                TextField("Company", text: $cardData.company)
              }

              Section(header: Text("Styling")) {
                ColorPicker("Background Color", selection: $cardData.backgroundColorFront)
                ColorPicker("Text Color", selection: $cardData.textColorFront)
                SliderField(
                  title: "Font Size",
                  value: $cardData.fontSizeFront,
                  range: 12...24
                )
              }
            } else {
              Section(header: Text("Contact Information")) {
                TextField("Email", text: $cardData.email)
                TextField("Phone", text: $cardData.phone)
                TextField("Website", text: $cardData.website)
              }

              Section(header: Text("Styling")) {
                ColorPicker("Background Color", selection: $cardData.backgroundColorBack)
                ColorPicker("Text Color", selection: $cardData.textColorBack)
                SliderField(
                  title: "Font Size",
                  value: $cardData.fontSizeBack,
                  range: 10...20
                )
              }
            }
          }
          .animation(.easeInOut(duration: 0.3), value: activeCardIndex)
        }
        .background(Color(.systemGroupedBackground))
      }
    }
  }
}

struct SliderField: View {
  let title: String
  @Binding var value: Double
  let range: ClosedRange<Double>

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(title)
        Spacer()
        Text("\(Int(value))")
          .foregroundColor(.secondary)
      }
      Slider(value: $value, in: range)
    }
  }
}

#Preview {
  EditView()
}
