import SwiftUI

struct FieldDescriptor<T> {
  var title: String
  var binding: Binding<T>
}

struct CardEditor: View {
  @Bindable var card: CardDraft
  var side: CardSide

  init(for side: CardSide, card: CardDraft) {
    self.card = card
    self.side = side
  }

  var personalInformationFields: [FieldDescriptor<String>] {
    var fields: [FieldDescriptor<String>] = []

    switch (card.style.designStyle, side) {
    case (.minimal, .front):
      fields.append(FieldDescriptor(title: "Name", binding: $card.name))
      fields.append(FieldDescriptor(title: "Title", binding: $card.title))
    case (.minimal, .back):
      fields.append(FieldDescriptor(title: "Company", binding: $card.company))
    case (.traditional, .front), (.modern, .front):
      fields.append(FieldDescriptor(title: "Name", binding: $card.name))
      fields.append(FieldDescriptor(title: "Title", binding: $card.title))
      fields.append(FieldDescriptor(title: "Company", binding: $card.company))
    case (_, _): break
    }

    if card.style.designStyle == .modern && side == .front {
      fields.append(FieldDescriptor(title: "Slogan", binding: $card.slogan))
    }

    return fields
  }

  var body: some View {
    Section(header: Text("Styling")) {
      Picker("Card Style", selection: $card.style.designStyle) {
        Text("Modern").tag(Card.DesignType.modern)
        Text("Traditional").tag(Card.DesignType.traditional)
        Text("Minimal").tag(Card.DesignType.minimal)
      }

      ColorPicker("Background Color", selection: $card.style.primaryColor)
      ColorPicker("Text Color", selection: $card.style.secondaryColor)
      Picker("Font", selection: $card.style.fontName) {
        ForEach(UIFont.familyNames, id: \.self) { family in
          Text(family).tag(family)
            .font(.custom(family, size: 14))
        }
      }
      .pickerStyle(.navigationLink)
    }

    if personalInformationFields.count > 0 {
      Section(header: Text("Personal Information")) {
        ForEach(personalInformationFields, id: \.title) { field in
          TextField(field.title, text: field.binding)
        }
      }
    }

    if side == .front && card.style.designStyle == .modern
      || side == .back && card.style.designStyle != .modern
    {
      Section(header: Text("Contact Information")) {
        TextField("Email", text: $card.contactInformation.email)
        TextField("Phone", text: $card.contactInformation.phoneNumber)
        TextField("Fax", text: $card.contactInformation.faxNumber)
        TextField("Website", text: $card.contactInformation.websiteURL)
        TextField("LinkedIn", text: $card.contactInformation.linkedInURL)
      }
    }

    if side == .back {
      Section(header: Text("Business Address")) {
        TextField("Street", text: $card.businessAddress.street)
        TextField("City", text: $card.businessAddress.city)
        TextField("State", text: $card.businessAddress.state)
        TextField("Postal Code", text: $card.businessAddress.postalCode)
        TextField("Country", text: $card.businessAddress.country)
      }

      Section(header: Text("Personal Address")) {
        TextField("Street", text: $card.personalAddress.street)
        TextField("City", text: $card.personalAddress.city)
        TextField("State", text: $card.personalAddress.state)
        TextField("Postal Code", text: $card.personalAddress.postalCode)
        TextField("Country", text: $card.personalAddress.country)
      }
    }
  }
}
