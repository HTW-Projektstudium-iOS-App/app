import SwiftUI

/// Traditional card design implementation
struct TraditionalCardDesign: CardContentDesign {
    let card: Card
    let showInfoAction: () -> Void

    /// Front side: company, role, logo, name, info button
    func frontContent() -> some View {
        ZStack {
            // Main colored background
            Rectangle()
                .fill(card.style.primaryColor)

            VStack {
                // Top right: company, role, logo
                HStack(alignment: .top) {
                    Spacer()
                    VStack(alignment: .trailing) {
                        HStack {
                            if let company = card.company {
                                Text(company)
                                    .font(
                                        CardElements.customFont(
                                            name: card.style.fontName,
                                            size: TraditionalCardDesignConstants.headerFontSize
                                        )
                                    )
                                    .foregroundColor(
                                        card.style.secondaryColor
                                            ?? CardDesign.Colors.primary
                                    )
                            }
                            if let role = card.role {
                                Text("| \(role)")
                                    .font(
                                        CardElements.customFont(
                                            name: card.style.fontName,
                                            size: TraditionalCardDesignConstants.headerFontSize
                                        )
                                    )
                                    .foregroundColor(
                                        card.style.secondaryColor
                                            ?? CardDesign.Colors.primary
                                    )
                            }
                        }
                        // Logo (first logo from the array)
                        CardElements.logo(
                            logos: card.logos,
                            color: card.style.secondaryColor,
                            shape: .oval,
                            width: TraditionalCardDesignConstants.logoWidth,
                            height: TraditionalCardDesignConstants.logoHeight,
                            contentWidth: TraditionalCardDesignConstants.logoContentWidth,
                            contentHeight: TraditionalCardDesignConstants.logoContentHeight
                        )
                    }
                }

                Spacer()

                // Name (large, bottom left)
                Text(card.name)
                    .font(
                        CardElements.customFont(
                            name: card.style.fontName,
                            size: TraditionalCardDesignConstants.nameFontSize,
                            weight: TraditionalCardDesignConstants.nameFontWeight
                        )
                    )
                    .foregroundColor(
                        card.style.secondaryColor ?? CardDesign.Colors.primary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, TraditionalCardDesignConstants.nameBottomPadding)
            }
            .padding(TraditionalCardDesignConstants.contentPadding)

            // Info button (bottom right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                }
            }
            .padding(TraditionalCardDesignConstants.contentPadding)
        }
    }

    /// Back side: website, three logos, contact info, info button
    func backContent() -> some View {
        ZStack {
            // Faded background
            Rectangle()
                .fill(card.style.primaryColor.opacity(TraditionalCardDesignConstants.backBackgroundOpacity))

            VStack {
                // Website URL at top right
                HStack {
                    Spacer()
                    if let website = card.contactInformation.websiteURL?.absoluteString {
                        Text(website)
                            .font(
                                CardElements.customFont(
                                    name: card.style.fontName,
                                    size: TraditionalCardDesignConstants.headerFontSize
                                )
                            )
                            .foregroundColor(
                                card.style.secondaryColor
                                    ?? CardDesign.Colors.primary
                            )
                            .italic()
                    }
                }
                .padding(.top, TraditionalCardDesignConstants.topPadding)
                .padding(.horizontal, TraditionalCardDesignConstants.contentPadding)

                Spacer()

                // Three logos (centered, stacked)
                VStack(spacing: TraditionalCardDesignConstants.logoStackSpacing) {
                    HStack(spacing: TraditionalCardDesignConstants.logoHStackSpacing) {
                        CardElements.logo(
                            index: 0,
                            logos: card.logos,
                            color: card.style.secondaryColor,
                            shape: .oval,
                            width: TraditionalCardDesignConstants.logoWidth,
                            height: TraditionalCardDesignConstants.logoHeight,
                            contentWidth: TraditionalCardDesignConstants.logoContentWidth,
                            contentHeight: TraditionalCardDesignConstants.logoContentHeight
                        )
                        CardElements.logo(
                            index: 1,
                            logos: card.logos,
                            color: card.style.secondaryColor,
                            shape: .oval,
                            width: TraditionalCardDesignConstants.logoWidth,
                            height: TraditionalCardDesignConstants.logoHeight,
                            contentWidth: TraditionalCardDesignConstants.logoContentWidth,
                            contentHeight: TraditionalCardDesignConstants.logoContentHeight
                        )
                    }
                    CardElements.logo(
                        index: 2,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .oval,
                        width: TraditionalCardDesignConstants.logoWidth,
                        height: TraditionalCardDesignConstants.logoHeight,
                        contentWidth: TraditionalCardDesignConstants.logoContentWidth,
                        contentHeight: TraditionalCardDesignConstants.logoContentHeight
                    )
                }

                Spacer()

                // Contact information (bottom right)
                VStack(alignment: .trailing, spacing: CardDesign.Padding.small) {
                    if let phone = card.contactInformation.phoneNumber {
                        Text(phone)
                            .font(
                                CardElements.customFont(
                                    name: card.style.fontName,
                                    size: TraditionalCardDesignConstants.headerFontSize
                                )
                            )
                            .foregroundColor(
                                card.style.secondaryColor
                                    ?? CardDesign.Colors.primary
                            )
                            .italic()
                    }
                    if let linkedIn = card.contactInformation.linkedInURL?.absoluteString {
                        Text(linkedIn)
                            .font(
                                CardElements.customFont(
                                    name: card.style.fontName,
                                    size: TraditionalCardDesignConstants.headerFontSize
                                )
                            )
                            .foregroundColor(
                                card.style.secondaryColor
                                    ?? CardDesign.Colors.primary
                            )
                            .italic()
                    }
                    if let email = card.contactInformation.email {
                        Text(email)
                            .font(
                                CardElements.customFont(
                                    name: card.style.fontName,
                                    size: TraditionalCardDesignConstants.headerFontSize
                                )
                            )
                            .foregroundColor(
                                card.style.secondaryColor
                                    ?? CardDesign.Colors.primary
                            )
                            .italic()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, TraditionalCardDesignConstants.contentPadding)
                .padding(.bottom, TraditionalCardDesignConstants.bottomPadding)
            }

            // Info button (bottom left)
            VStack {
                Spacer()
                HStack {
                    CardElements.infoButton(card: card, action: showInfoAction)
                        .padding(.leading, TraditionalCardDesignConstants.infoButtonLeadingPadding)
                    Spacer()
                }
            }
            .padding(.bottom, TraditionalCardDesignConstants.bottomPadding)
        }
    }
}
