import MapKit
import SwiftUI

/// A sheet view displaying detailed information about a card.
/// Shows card header, contact info, address, and collection data.
struct CardInfoSheet: View {
  let card: Card
  @Binding var isPresented: Bool
  @State private var showAddSuccess = false
  @State private var showAddError = false
  @State private var addErrorMsg = ""

  let contactService = ContactService()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        cardHeader

        // Show contact section if any contact info exists
        if card.contactInformation.hasAnyInformation {
          contactSection
        }

        // Show address section if address info exists
        if let address = card.businessAddress,
          address.hasAnyInformation
        {
          addressSection(address)
        }

        collectionDataSection
      }
      .padding()
    }
    .ignoresSafeArea()
    .background(Color(.systemBackground))
    // Add close button at the bottom, respecting safe area
    .safeAreaInset(edge: .bottom) {
      VStack(spacing: 8) {
        addToContactsButton
        closeButton
      }
      .background(.ultraThinMaterial)
    }
  }

  /// Card header with name, title, and company
  private var cardHeader: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(card.name)
        .font(CardElements.customFont(name: card.style.fontName, size: 32, weight: .heavy))
        .foregroundColor(card.style.secondaryColor ?? .black)

      // Optional title
      if let title = card.title {
        Text(title)
          .font(CardElements.customFont(name: card.style.fontName, size: 24, weight: .bold))
          .foregroundColor(card.style.secondaryColor ?? .gray)
      }

      // Optional company
      if let company = card.company {
        Text(company)
          .font(CardElements.customFont(name: card.style.fontName, size: 16))
          .foregroundColor(card.style.secondaryColor ?? .black)
      }
    }
    .padding(.bottom, 4)
  }

  /// Section for contact information (email, phone, fax, website, LinkedIn)
  private var contactSection: some View {
    Group {
      Text("Contact Information")
        .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .semibold))
        .foregroundColor(card.style.secondaryColor ?? .black)

      VStack(alignment: .leading, spacing: 6) {
        contactItem(
          icon: "envelope",
          text: card.contactInformation.email
        )
        contactItem(
          icon: "phone",
          text: card.contactInformation.phoneNumber
        )
        contactItem(
          icon: "printer",
          text: card.contactInformation.faxNumber
        )

        if let website = card.contactInformation.websiteURL {
          contactItem(icon: "globe", text: website)
        }

        if let linkedin = card.contactInformation.linkedInURL {
          contactItem(icon: "link", text: linkedin)
        }
      }

      divider
    }
  }

  /// Helper for displaying a contact item with icon and text
  private func contactItem(icon: String, text: String?) -> some View {
    Group {
      if let text = text {
        HStack(alignment: .top) {
          Image(systemName: icon)
            .frame(width: 20)
          Text(text)
            .font(CardElements.customFont(name: card.style.fontName, size: 14))
        }
        .foregroundColor(card.style.secondaryColor ?? .black)
      }
    }
  }

  /// Section for business address, if available
  private func addressSection(_ address: Card.Address) -> some View {
    Group {
      Text("Business Address")
        .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .semibold))
        .foregroundColor(card.style.secondaryColor ?? .black)

      HStack(alignment: .top) {
        Image(systemName: "building")
          .frame(width: 20)
        Text(address.formattedAddress ?? "")
          .font(CardElements.customFont(name: card.style.fontName, size: 14))
          .multilineTextAlignment(.leading)
      }
      .foregroundColor(card.style.secondaryColor ?? .black)

      divider
    }
  }

  /// Section for collection date and location
  private var collectionDataSection: some View {
    Group {
      Text("Collection Data")
        .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .semibold))
        .foregroundColor(
          card.style.secondaryColor ?? .black
        )

      HStack(alignment: .top) {
        Image(systemName: "calendar")
          .frame(width: 20)
        Text(
          card.collectionDate.formatted(date: .long, time: .shortened)
        )
        .font(CardElements.customFont(name: card.style.fontName, size: 14))
      }
      .foregroundColor(
        card.style.secondaryColor ?? .black
      )

      HStack(alignment: .top) {
        Image(systemName: "mappin.and.ellipse")
          .frame(width: 20)
        Text(
          """
          \(card.collectionLocation.latitude, specifier: "%.4f")  \
          \(card.collectionLocation.longitude, specifier: "%.4f")
          """
        )
        .font(CardElements.customFont(name: card.style.fontName, size: 14))
      }
      .foregroundColor(
        card.style.secondaryColor ?? .black
      )

      Map(
        initialPosition: MapCameraPosition.region(
          MKCoordinateRegion(
            center: card.collectionLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
        interactionModes: []
      ) {
        Marker("Collection Location", coordinate: card.collectionLocation)
      }
      .frame(height: 150)
      .clipShape(RoundedRectangle(cornerRadius: 8))

    }
  }

  /// Divider with card-specific color
  private var divider: some View {
    Divider()
      .background(card.style.secondaryColor?.opacity(0.5) ?? Color.gray.opacity(0.5))
      .padding(.vertical, 4)
  }

  /// add to contact button
  private var addToContactsButton: some View {
    Button(action: {
      contactService.save(card: card) { result in
        switch result {
        case .success:
          showAddSuccess = true
        case .failure(let err):
          addErrorMsg = err.localizedDescription
          showAddError = true
        }
      }
    }) {
      Text("Add to Contacts")
        .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .medium))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    .buttonStyle(.borderedProminent)
    .tint(card.style.secondaryColor ?? .accentColor)
    .padding(.horizontal)
    .alert("Contact Added", isPresented: $showAddSuccess) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("This card has been saved to your Contacts.")

    }
    .alert("Error", isPresented: $showAddError) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(addErrorMsg)
    }
  }

  /// Close button at the bottom of the sheet
  private var closeButton: some View {
    Button(action: { isPresented = false }) {
      Text("Close")
        .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .medium))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
    .buttonStyle(.borderedProminent)
    .tint(card.style.secondaryColor ?? .blue)
    .padding(.horizontal, 16)
  }
}
