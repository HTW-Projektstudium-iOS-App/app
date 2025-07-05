import SwiftUI

/// Minimal card design implementation
struct MinimalCardDesign: CardContentDesign {
    let card: Card
    let showInfoAction: () -> Void

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

    /// Front side of the card: monogram, name, role, info button
    func frontContent() -> some View {
        ZStack {
            // Background with subtle border
            Rectangle()
                .fill(card.style.primaryColor)
                .overlay(
                    Rectangle()
                        .stroke(
                            (card.style.secondaryColor ?? CardDesign.Colors.primary)
                                .opacity(MinimalCardDesignConstants.borderOpacity),
                            lineWidth: MinimalCardDesignConstants.borderLineWidth
                        )
                )

            // Large monogram in Zapfino font, faded (keeps original color)
            Text(getMonogramInitials())
                .font(.custom(MinimalCardDesignConstants.monogramFontName, size: MinimalCardDesignConstants.monogramFontSize).weight(MinimalCardDesignConstants.monogramFontWeight))
                .foregroundColor(Color.gray.opacity(MinimalCardDesignConstants.monogramOpacity))
                .offset(y: MinimalCardDesignConstants.monogramYOffset)
                .padding(0)

            // Name and role stacked vertically
            VStack(spacing: MinimalCardDesignConstants.vStackSpacing) {
                Text(card.name)
                    .font(
                        CardElements.customFont(
                            name: card.style.fontName,
                            size: MinimalCardDesignConstants.nameFontSize,
                            weight: MinimalCardDesignConstants.nameFontWeight
                        )
                    )
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

                if let role = card.role {
                    Text(role)
                        .font(
                            CardElements.customFont(
                                name: card.style.fontName,
                                size: MinimalCardDesignConstants.roleFontSize
                            )
                        )
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                }
            }
            .padding(0)

            // Info button at bottom right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                        .padding(.bottom, MinimalCardDesignConstants.infoButtonBottomPadding)
                        .padding(.trailing, MinimalCardDesignConstants.infoButtonTrailingPadding)
                }
            }
        }
        .frame(maxHeight: MinimalCardDesignConstants.frameMaxHeight)
        .clipShape(Rectangle())
    }

    /// Back side: company, social icons, contact info, info button
    func backContent() -> some View {
        ZStack {
            // Background with subtle border
            Rectangle()
                .fill(card.style.primaryColor)
                .overlay(
                    Rectangle()
                        .stroke(
                            (card.style.secondaryColor ?? CardDesign.Colors.primary)
                                .opacity(MinimalCardDesignConstants.borderOpacity),
                            lineWidth: MinimalCardDesignConstants.borderLineWidth
                        )
                )

            VStack {
                // Company name at top (if available)
                if let company = card.company {
                    Text(company.uppercased())
                        .font(
                            CardElements.customFont(
                                name: card.style.fontName,
                                size: MinimalCardDesignConstants.companyFontSize,
                                weight: MinimalCardDesignConstants.companyFontWeight
                            )
                        )
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        .padding(.top, MinimalCardDesignConstants.companyTopPadding)
                }

                Spacer()

                // Main content near bottom: social icons and contact info
                VStack(spacing: MinimalCardDesignConstants.backContentVStackSpacing) {
                    HStack(alignment: .center, spacing: MinimalCardDesignConstants.socialIconsHStackSpacing) {
                        // Social media icons and username (keeps original color)
                        VStack(alignment: .center, spacing: MinimalCardDesignConstants.socialIconsVStackSpacing) {
                            HStack(spacing: MinimalCardDesignConstants.socialIconSpacing) {
                                socialIcon(text: "in")
                                socialIcon(text: "ig")
                                socialIcon(text: "X")
                                socialIcon(text: "OF")
                            }
                            Text("@username")
                                .font(
                                    CardElements.customFont(
                                        name: card.style.fontName,
                                        size: MinimalCardDesignConstants.contactFontSize
                                    )
                                )
                                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        }

                        // Vertical divider
                        Rectangle()
                            .fill(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            .frame(width: MinimalCardDesignConstants.dividerWidth, height: MinimalCardDesignConstants.dividerHeight)

                        // Contact details
                        VStack(alignment: .leading, spacing: MinimalCardDesignConstants.contactVStackSpacing) {
                            contactItem(
                                text: card.contactInformation.websiteURL?
                                    .absoluteString ?? "www.website.com"
                            )
                            contactItem(
                                text: card.contactInformation.email
                                    ?? "company@email.com"
                            )
                            contactItem(
                                text: card.contactInformation.phoneNumber
                                    ?? "1076-14734920"
                            )
                        }
                    }
                    .padding(.horizontal, MinimalCardDesignConstants.contentHStackPadding)
                    .padding(.bottom, MinimalCardDesignConstants.contentBottomPadding)
                }
            }

            // Info button at bottom right
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                        .padding([.bottom, .trailing], MinimalCardDesignConstants.infoButtonBottomPadding)
                }
            }
        }
    }

    /// Social icon in a gray circle with label (keeps original color)
    private func socialIcon(text: String) -> some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(MinimalCardDesignConstants.socialIconCircleOpacity))
                .frame(width: MinimalCardDesignConstants.socialIconCircleSize, height: MinimalCardDesignConstants.socialIconCircleSize)

            Text(text)
                .font(
                    CardElements.customFont(name: card.style.fontName, size: MinimalCardDesignConstants.socialIconFontSize)
                )
                .foregroundColor(.white)
        }
    }

    /// Contact info item, styled
    private func contactItem(text: String) -> some View {
        Text(text)
            .font(CardElements.customFont(name: card.style.fontName, size: MinimalCardDesignConstants.contactFontSize))
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
    }
}
