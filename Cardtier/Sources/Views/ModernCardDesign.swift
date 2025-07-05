import SwiftUI

/// Modern card design implementation
struct ModernCardDesign: CardContentDesign {
    let card: Card
    let showInfoAction: () -> Void

    func frontContent() -> some View {
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
                        width: ModernCardDesignConstants.logoWidth,
                        height: ModernCardDesignConstants.logoHeight,
                        contentWidth: ModernCardDesignConstants.logoContentWidth,
                        contentHeight: ModernCardDesignConstants.logoContentHeight
                    )
                    .padding([.top, .leading], CardDesign.Padding.small)
                    Spacer()
                }
                Spacer()
            }
    
            // "Global Industries | Research" in the top right, vertically centered to logo
            VStack {
                HStack {
                    Spacer()
                    if let company = card.company, let role = card.role {
                        Text("\(company) | \(role)")
                            .font(
                                CardElements.customFont(
                                    name: card.style.fontName,
                                    size: ModernCardDesignConstants.headerFontSize
                                )
                            )
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            .padding(.top, CardDesign.Padding.small + ModernCardDesignConstants.logoHeight / 2)
                            .padding(.trailing, CardDesign.Padding.small)
                    }
                }
                Spacer()
            }
    
            // Main content
            VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
                Spacer().frame(height: ModernCardDesignConstants.logoHeight + CardDesign.Padding.large * 1.5)
    
                // Name
                Text(card.name.uppercased())
                    .font(
                        CardElements.customFont(
                            name: card.style.fontName,
                            size: ModernCardDesignConstants.nameFontSize,
                            weight: ModernCardDesignConstants.nameFontWeight
                        )
                    )
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                    .padding(.top, CardDesign.Padding.small)
    
                // Contact information
                HStack(alignment: .top, spacing: CardDesign.Padding.medium) {
                    CardElements.logo(
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .square,
                        width: ModernCardDesignConstants.contactLogoWidth,
                        height: ModernCardDesignConstants.contactLogoHeight,
                        contentWidth: ModernCardDesignConstants.contactLogoContentWidth,
                        contentHeight: ModernCardDesignConstants.contactLogoContentHeight
                    )
    
                    VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
                        contactItem(label: "Email:", value: card.contactInformation.email)
                        contactItem(label: "Handynummer:", value: card.contactInformation.phoneNumber)
                    }
    
                    Spacer()
    
                    VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
                        contactItem(label: "Website:", value: card.contactInformation.websiteURL?.absoluteString)
                        contactItem(label: "LinkedIN:", value: card.contactInformation.linkedInURL?.host)
                    }
                }
    
                // Slogan bullets
                if let slogan = card.slogan {
                    Spacer()
                    VStack(alignment: .leading, spacing: ModernCardDesignConstants.bulletSpacing) {
                        ForEach(slogan.components(separatedBy: " - "), id: \.self) { item in
                            HStack(alignment: .top, spacing: ModernCardDesignConstants.bulletSymbolSpacing) {
                                Text("•")
                                    .font(
                                        CardElements.customFont(
                                            name: card.style.fontName,
                                            size: ModernCardDesignConstants.bulletFontSize
                                        )
                                    )
                                Text(item)
                                    .font(
                                        CardElements.customFont(
                                            name: card.style.fontName,
                                            size: ModernCardDesignConstants.bulletFontSize
                                        )
                                    )
                            }
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        }
                    }
                }
            }
            .padding(CardDesign.Padding.small)
    
            // Info button in the absolute bottom right corner
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                        .padding([.bottom, .trailing], CardDesign.Padding.small)
                }
            }
        }
    }

    private func contactItem(label: String, value: String?) -> some View {
        Group {
            if let value = value {
                VStack(alignment: .leading, spacing: 0) {
                    Text(label)
                        .font(
                            CardElements.customFont(
                                name: card.style.fontName,
                                size: ModernCardDesignConstants.contactLabelFontSize,
                                weight: ModernCardDesignConstants.contactLabelFontWeight
                            )
                        )
                    Text(value)
                        .font(
                            CardElements.customFont(
                                name: card.style.fontName,
                                size: ModernCardDesignConstants.contactValueFontSize
                            )
                        )
                }
                .foregroundColor(
                    card.style.secondaryColor ?? CardDesign.Colors.primary
                )
            }
        }
    }

    func backContent() -> some View {
        ZStack {
            // Background
            Rectangle()
                .fill(card.style.primaryColor)

            VStack {
                Spacer()

                // Row of circular logos centered with different sizes
                HStack(spacing: ModernCardDesignConstants.backLogoSpacings) {
                    // Smaller logo (left)
                    CardElements.logo(
                        index: 0,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: ModernCardDesignConstants.backLogoSmall,
                        height: ModernCardDesignConstants.backLogoSmall,
                        contentWidth: ModernCardDesignConstants.backLogoContentSmall,
                        contentHeight: ModernCardDesignConstants.backLogoContentSmall
                    )

                    // Medium logo (left)
                    CardElements.logo(
                        index: 1,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: ModernCardDesignConstants.backLogoMedium,
                        height: ModernCardDesignConstants.backLogoMedium,
                        contentWidth: ModernCardDesignConstants.backLogoContentMedium,
                        contentHeight: ModernCardDesignConstants.backLogoContentMedium
                    )

                    // Large logo (center)
                    CardElements.logo(
                        index: 2,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: ModernCardDesignConstants.backLogoLarge,
                        height: ModernCardDesignConstants.backLogoLarge,
                        contentWidth: ModernCardDesignConstants.backLogoContentLarge,
                        contentHeight: ModernCardDesignConstants.backLogoContentLarge
                    )

                    // Medium logo (right)
                    CardElements.logo(
                        index: 3,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: ModernCardDesignConstants.backLogoMedium,
                        height: ModernCardDesignConstants.backLogoMedium,
                        contentWidth: ModernCardDesignConstants.backLogoContentMedium,
                        contentHeight: ModernCardDesignConstants.backLogoContentMedium
                    )

                    // Smaller logo (right)
                    CardElements.logo(
                        index: 4,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: ModernCardDesignConstants.backLogoSmall,
                        height: ModernCardDesignConstants.backLogoSmall,
                        contentWidth: ModernCardDesignConstants.backLogoContentSmall,
                        contentHeight: ModernCardDesignConstants.backLogoContentSmall
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
            .padding(CardDesign.Padding.small)
        }
    }
}
