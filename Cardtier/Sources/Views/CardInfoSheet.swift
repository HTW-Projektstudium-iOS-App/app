import SwiftUI

/// A sheet view displaying detailed information about a card.
/// Shows card header, contact info, address, and collection data.
struct CardInfoSheet: View {
    let card: Card
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CardDesign.Padding.large) {
                cardHeader

                // Show contact section if any contact info exists
                if card.contactInformation.hasAnyInformation {
                    contactSection
                }

                // Show address section if address info exists
                if let address = card.businessAddress,
                    address.hasAddressInformation
                {
                    addressSection(address)
                }

                collectionDataSection

                Spacer(minLength: CardDesign.Padding.large)
            }
            .padding(CardDesign.Padding.standard)
        }
        // Add close button at the bottom, respecting safe area
        .safeAreaInset(edge: .bottom) {
            closeButton
        }
        .background(Color(.systemBackground))
    }

    /// Card header with name, title, and company
    private var cardHeader: some View {
        VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
            Text(card.name)
                .font(
                    CardElements.customFont(
                        name: card.style.fontName,
                        size: CardInfoSheetConstants.headerFontSize,
                        weight: .bold
                    )
                )
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )

            // Optional title
            if let title = card.title {
                Text(title)
                    .font(
                        CardElements.customFont(
                            name: card.style.fontName,
                            size: CardInfoSheetConstants.titleFontSize,
                            weight: .medium
                        )
                    )
                    .foregroundColor(
                        card.style.secondaryColor ?? CardDesign.Colors.secondary
                    )
            }

            // Optional company
            if let company = card.company {
                Text(company)
                    .font(
                        CardElements.customFont(
                            name: card.style.fontName,
                            size: CardInfoSheetConstants.companyFontSize
                        )
                    )
                    .foregroundColor(
                        card.style.secondaryColor ?? CardDesign.Colors.primary
                    )
            }
        }
        .padding(.bottom, CardDesign.Padding.small)
    }

    /// Section for contact information (email, phone, fax, website, LinkedIn)
    private var contactSection: some View {
        Group {
            Text("Contact Information")
                .font(
                    CardElements.customFont(
                        name: card.style.fontName,
                        size: CardInfoSheetConstants.sectionTitleFontSize,
                        weight: CardInfoSheetConstants.sectionTitleFontWeight
                    )
                )
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )

            VStack(alignment: .leading, spacing: CardDesign.Padding.medium - CardInfoSheetConstants.spacingAdjustment)
            {
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
                    contactItem(icon: "globe", text: website.absoluteString)
                }

                if let linkedin = card.contactInformation.linkedInURL {
                    contactItem(icon: "link", text: linkedin.absoluteString)
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
                        .frame(width: CardInfoSheetConstants.iconFrameWidth)
                    Text(text)
                        .font(
                            CardElements.customFont(
                                name: card.style.fontName,
                                size: CardInfoSheetConstants.itemFontSize
                            )
                        )
                }
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )
            }
        }
    }

    /// Section for business address, if available
    private func addressSection(_ address: Address) -> some View {
        Group {
            Text("Business Address")
                .font(
                    CardElements.customFont(
                        name: card.style.fontName,
                        size: CardInfoSheetConstants.sectionTitleFontSize,
                        weight: CardInfoSheetConstants.sectionTitleFontWeight
                    )
                )
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )

            HStack(alignment: .top) {
                Image(systemName: "building")
                    .frame(width: CardInfoSheetConstants.iconFrameWidth)
                Text(address.formattedAddress ?? "")
                    .font(
                        CardElements.customFont(
                            name: card.style.fontName,
                            size: CardInfoSheetConstants.itemFontSize
                        )
                    )
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(
                card.style.secondaryColor ?? CardDesign.Colors.primary
            )

            divider
        }
    }

    /// Section for collection date and location
    private var collectionDataSection: some View {
        Group {
            Text("Collection Data")
                .font(
                    CardElements.customFont(
                        name: card.style.fontName,
                        size: CardInfoSheetConstants.sectionTitleFontSize,
                        weight: CardInfoSheetConstants.sectionTitleFontWeight
                    )
                )
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )

            HStack(alignment: .top) {
                Image(systemName: "calendar")
                    .frame(width: CardInfoSheetConstants.iconFrameWidth)
                Text(
                    card.collectionDate.formatted(date: .long, time: .shortened)
                )
                .font(
                    CardElements.customFont(name: card.style.fontName, size: CardInfoSheetConstants.itemFontSize)
                )
            }
            .foregroundColor(
                card.style.secondaryColor ?? CardDesign.Colors.primary
            )

            HStack(alignment: .top) {
                Image(systemName: "mappin.and.ellipse")
                    .frame(width: CardInfoSheetConstants.iconFrameWidth)
                Text(
                    "\(card.collectionLocation.latitude, specifier: CardInfoSheetConstants.coordinateFormat), \(card.collectionLocation.longitude, specifier: CardInfoSheetConstants.coordinateFormat)"
                )
                .font(
                    CardElements.customFont(name: card.style.fontName, size: CardInfoSheetConstants.itemFontSize)
                )
            }
            .foregroundColor(
                card.style.secondaryColor ?? CardDesign.Colors.primary
            )
        }
    }

    /// Divider with card-specific color
    private var divider: some View {
        Divider()
            .background(
                card.style.secondaryColor?.opacity(CardInfoSheetConstants.dividerOpacity)
                    ?? Color.gray.opacity(CardInfoSheetConstants.dividerOpacity)
            )
            .padding(.vertical, CardDesign.Padding.small)
    }

    /// Close button at the bottom of the sheet
    private var closeButton: some View {
        Button(action: { isPresented = false }) {
            Text("Close")
                .font(
                    CardElements.customFont(
                        name: card.style.fontName,
                        size: CardInfoSheetConstants.titleFontSize,
                        weight: .medium
                    )
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, CardDesign.Padding.medium)
        }
        .buttonStyle(.borderedProminent)
        .tint(card.style.secondaryColor ?? CardDesign.Colors.accent)
        .padding(.horizontal, CardDesign.Padding.standard)
        .padding(.bottom, CardDesign.Padding.small)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
}
