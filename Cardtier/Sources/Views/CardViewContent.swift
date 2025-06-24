import SwiftUI

/// Modern design for front card face
/// Features name, title, and company with left-aligned layout
struct ModernFrontCardContent: View {
    let card: Card
    let showInfoAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: CardDesign.Padding.large)
            
            VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
                Text(card.name)
                    .font(CardDesign.Typography.titleFont)
                    .bold()
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                
                if let title = card.title {
                    Text(title)
                        .font(CardDesign.Typography.headlineFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
                }
                
                if let company = card.company {
                    Text(company)
                        .font(CardDesign.Typography.subheadlineFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        .padding(.top, CardDesign.Padding.small / 2)
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(CardDesign.Typography.titleFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(CardDesign.Padding.standard)
    }
}


/// Modern design for back card face
/// Features contact information, address, and slogan with left-aligned layout
struct ModernBackCardContent: View {
    let card: Card
    let showInfoAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
                if let company = card.company {
                    Text(company)
                        .font(CardDesign.Typography.headlineFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                }
                
                if let role = card.role {
                    Text(role)
                        .font(CardDesign.Typography.subheadlineFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
                }
                
                if card.contactInformation.hasAnyInformation {
                    VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
                        if let email = card.contactInformation.email {
                            Text(email)
                                .font(CardDesign.Typography.footnoteFont)
                                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        }
                        
                        if let phone = card.contactInformation.phoneNumber {
                            Text(phone)
                                .font(CardDesign.Typography.footnoteFont)
                                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        }
                    }
                    .padding(.top, CardDesign.Padding.small)
                }
                
                if let address = card.businessAddress?.formattedAddress {
                    Text(address)
                        .font(CardDesign.Typography.footnoteFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        .padding(.top, CardDesign.Padding.small / 2)
                }
                
                if let slogan = card.slogan {
                    Text("\"\(slogan)\"")
                        .font(CardDesign.Typography.captionFont)
                        .italic()
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
                        .padding(.top, CardDesign.Padding.small)
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(CardDesign.Typography.titleFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(CardDesign.Padding.standard)
    }
}

/// Minimal design for front card face
/// Simplified, centered layout with just name and title
struct MinimalFrontCardContent: View {
    let card: Card
    let showInfoAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text(card.name)
                .font(CardDesign.Typography.titleFont)
                .bold()
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            
            if let title = card.title {
                Text(title)
                    .font(CardDesign.Typography.subheadlineFont)
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(CardDesign.Typography.titleFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(CardDesign.Padding.standard)
    }
}

struct MinimalBackCardContent: View {
    let card: Card
    let showInfoAction: () -> Void
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            if let company = card.company {
                Text(company)
                    .font(CardDesign.Typography.headlineFont)
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }
            
            if let email = card.contactInformation.email {
                Text(email)
                    .font(CardDesign.Typography.captionFont)
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
                    .padding(.top, CardDesign.Padding.small)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(CardDesign.Typography.titleFont)
                        .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(CardDesign.Padding.standard)
    }
}

/// Sheet displaying detailed metadata about a business card
/// Appears when user taps info button
struct CardInfoSheet: View {
    /// The card to display information for
    let card: Card
    
    /// Binding to control sheet presentation
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: CardDesign.Padding.large) {
            // Header with name
            Text(card.name)
                .font(CardDesign.Typography.headlineFont)
                .foregroundColor(CardDesign.Colors.primary)

            // Contact information section - only displayed if information exists
            if card.contactInformation.hasAnyInformation {
                Group {
                    Text("Contact Information")
                        .font(CardDesign.Typography.subheadlineFont)
                        .bold()
                        .foregroundColor(CardDesign.Colors.primary)

                    // List of contact details
                    VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
                        if let email = card.contactInformation.email {
                            Text("Email: \(email)")
                                .foregroundColor(CardDesign.Colors.primary)
                        }
                        if let phone = card.contactInformation.phoneNumber {
                            Text("Phone: \(phone)")
                                .foregroundColor(CardDesign.Colors.primary)
                        }
                        if let fax = card.contactInformation.faxNumber {
                            Text("Fax: \(fax)")
                                .foregroundColor(CardDesign.Colors.primary)
                        }
                        if let website = card.contactInformation.websiteURL {
                            Text("Website: \(website.absoluteString)")
                                .foregroundColor(CardDesign.Colors.primary)
                        }
                        if let linkedin = card.contactInformation.linkedInURL {
                            Text("LinkedIn: \(linkedin.absoluteString)")
                                .foregroundColor(CardDesign.Colors.primary)
                        }
                    }
                    Divider() // Visual separator
                }
            }

            // Address information - only displayed if information exists
            if let address = card.businessAddress, address.hasAnyInformation {
                Group {
                    Text("Business Address")
                        .font(CardDesign.Typography.subheadlineFont)
                        .bold()
                        .foregroundColor(CardDesign.Colors.primary)

                    Text(address.formattedAddress ?? "")
                        .foregroundColor(CardDesign.Colors.primary)

                    Divider() // Visual separator
                }
            }

            // Collection metadata - when and where the card was collected
            Group {
                Text("Collection Data")
                    .font(CardDesign.Typography.subheadlineFont)
                    .bold()
                    .foregroundColor(CardDesign.Colors.primary)

                Text("Date: \(card.collectionDate.formatted(date: .long, time: .shortened))")
                    .foregroundColor(CardDesign.Colors.primary)

                Text("Location: \(card.collectionLocation.latitude, specifier: "%.4f"), \(card.collectionLocation.longitude, specifier: "%.4f")")
                    .foregroundColor(CardDesign.Colors.primary)
            }

            Spacer() // Push content to top, button to bottom

            // Close button
            Button("Close") {
                isPresented = false
            }
            .frame(maxWidth: .infinity) // Full width button
            .padding(.vertical, CardDesign.Padding.medium)
            .background(CardDesign.Colors.accent)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(CardDesign.Padding.standard) // Padding around all content
        .background(Color(.systemBackground)) // System background color for light/dark mode
    }
}
