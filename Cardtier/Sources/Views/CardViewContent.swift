import SwiftUI

/// Main protocol for card content designs
protocol CardContentDesign {
    var card: Card { get }
    var showInfoAction: () -> Void { get }
    
    associatedtype FrontContent: View
    associatedtype BackContent: View
    
    func frontContent() -> FrontContent
    func backContent() -> BackContent
}

/// Factory for creating the appropriate card design with caching
struct CardContentFactory {
    // Cache to store created designs by card ID
    private static var designCache: [UUID: Any] = [:]
    
    static func makeDesign(for card: Card, showInfoAction: @escaping () -> Void) -> any CardContentDesign {
        // Check if we already have a cached design for this card
        if let cachedDesign = designCache[card.id] as? any CardContentDesign {
            return cachedDesign
        }
        
        // Create a new design based on style
        let design: any CardContentDesign
        switch card.style.designStyle {
        case .modern:
            design = ModernCardDesign(card: card, showInfoAction: showInfoAction)
        case .minimal:
            design = MinimalCardDesign(card: card, showInfoAction: showInfoAction)
        case .traditional:
            design = TraditionalCardDesign(card: card, showInfoAction: showInfoAction)
        }
        
        // Cache the new design
        designCache[card.id] = design
        return design
    }
    
    // Method to clear the cache if needed (e.g., when memory pressure is high)
    static func clearCache() {
        designCache.removeAll()
    }
}

/// Common elements used across card designs
struct CardElements {
    /// Shape options for placeholder logos
    public enum LogoShape {
        case oval
        case circle
        case square
    }
    
    /// Creates an info button with consistent styling
    static func infoButton(card: Card, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "info.circle")
                .font(CardDesign.Typography.titleFont)
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    /// Creates a logo with customizable shape, size and styling
    static func logo(
        index: Int = 0,
        logos: [UIImage]? = nil,
        color: Color?,
        shape: LogoShape = .oval,
        width: CGFloat = 95,
        height: CGFloat = 50,
        contentWidth: CGFloat = 85,
        contentHeight: CGFloat = 40
    ) -> some View {
        ZStack {
            // Background shape
            Group {
                switch shape {
                case .oval:
                    Ellipse()
                        .fill(Color.black.opacity(0.25))
                case .circle:
                    Circle()
                        .fill(Color.black.opacity(0.25))
                case .square:
                    Rectangle()
                        .fill(Color.black.opacity(0.25))
                }
            }
            .frame(width: width, height: height)
            
            // Inner highlight for depth
            Group {
                switch shape {
                case .oval:
                    Ellipse()
                        .fill(Color.white.opacity(0.15))
                case .circle:
                    Circle()
                        .fill(Color.white.opacity(0.15))
                case .square:
                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                }
            }
            .frame(width: width - 2, height: height - 2)
            
            // Shadow effect
            Group {
                switch shape {
                case .oval:
                    Ellipse()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1.5)
                case .circle:
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1.5)
                case .square:
                    Rectangle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 1.5)
                }
            }
            .frame(width: width - 4, height: height - 4)
            .blur(radius: 2)
            
            // Content
            if let logoArray = logos, index < logoArray.count {
                Image(uiImage: logoArray[index])
                    .resizable()
                    .scaledToFit()
                    .frame(width: contentWidth, height: contentHeight)
            } else if let placeholderURL = Bundle.main.url(forResource: "Noplaceholder", withExtension: "png"),
                      let placeholderImage = UIImage(contentsOfFile: placeholderURL.path) {
                Image(uiImage: placeholderImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: contentWidth, height: contentHeight)
            } else {
                // Fallback if no image is available
                Image(systemName: "apple.logo").imageScale(.large)
                    .foregroundColor(color?.opacity(0.8) ?? .white.opacity(0.8))
            }
        }
        .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 2)
    }
}

/// Modern card design implementation
struct ModernCardDesign: CardContentDesign {
    let card: Card
    let showInfoAction: () -> Void
    
    func frontContent() -> some View {
        ZStack {
            // Background
            Rectangle()
                .fill(card.style.primaryColor)
            
            VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
                // Header mit Logo links und Company/Role rechts
                HStack {
                    // Logo oben links
                    CardElements.logo(
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: 30,
                        height: 30,
                        contentWidth: 25,
                        contentHeight: 25
                    )
                    
                    Spacer()
                    
                    // Company und Role rechts
                    if let company = card.company {
                        Text("\(company)\(card.role != nil ? " | \(card.role!)" : "")")
                            .font(CardElements.customFont(name: card.style.fontName, size: 12))
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                    }
                }
                
                // Large name display
                Text(card.name.uppercased())
                    .font(CardElements.customFont(name: card.style.fontName, size: 28, weight: .black))
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                    .padding(.top, CardDesign.Padding.small)
                
                // Contact information section with reduced spacing
                HStack(alignment: .top, spacing: CardDesign.Padding.medium) {
                    // QR code placeholder on the left
                    CardElements.logo(
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .square,
                        width: 70,
                        height: 70,
                        contentWidth: 60,
                        contentHeight: 60
                    )
                    
                    // Contact details in two columns with reduced spacing
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
                
                // Bottom bullet points for skills/interests
                if let slogan = card.slogan {
                    Spacer()
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(slogan.components(separatedBy: " - "), id: \.self) { item in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(CardElements.customFont(name: card.style.fontName, size: 10))
                                Text(item)
                                    .font(CardElements.customFont(name: card.style.fontName, size: 10))
                            }
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                        }
                    }
                }
                
                // Info button
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                }
            }
            .padding(CardDesign.Padding.small)
        }
    }
    
    private func contactItem(label: String, value: String?) -> some View {
        Group {
            if let value = value {
                VStack(alignment: .leading, spacing: 0) {
                    Text(label)
                        .font(CardElements.customFont(name: card.style.fontName, size: 10, weight: .bold))
                    Text(value)
                        .font(CardElements.customFont(name: card.style.fontName, size: 10))
                }
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
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
                HStack(spacing: 10) {
                    // Smaller logo (left)
                    CardElements.logo(
                        index: 0,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: 45,
                        height: 45,
                        contentWidth: 35,
                        contentHeight: 35
                    )
                    
                    // Medium logo (left)
                    CardElements.logo(
                        index: 1,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: 55,
                        height: 55,
                        contentWidth: 45,
                        contentHeight: 45
                    )
                    
                    // Large logo (center)
                    CardElements.logo(
                        index: 2,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: 65,
                        height: 65,
                        contentWidth: 55,
                        contentHeight: 55
                    )
                    
                    // Medium logo (right)
                    CardElements.logo(
                        index: 3,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: 55,
                        height: 55,
                        contentWidth: 45,
                        contentHeight: 45
                    )
                    
                    // Smaller logo (right)
                    CardElements.logo(
                        index: 4,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .circle,
                        width: 45,
                        height: 45,
                        contentWidth: 35,
                        contentHeight: 35
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

/// Minimal card design implementation
struct MinimalCardDesign: CardContentDesign {
    let card: Card
    let showInfoAction: () -> Void
    
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
    
    func frontContent() -> some View {
        ZStack {
            // Background - white with subtle border
            Rectangle()
                .fill(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
            
            // Background monogram with Zapfino font
            Text(getMonogramInitials())
                .font(.custom("Zapfino", size: 60).weight(.thin))
                .foregroundColor(Color.gray.opacity(0.25))
                .offset(y: 10)
                .padding(0)  // No padding on the monogram
            
            // Content container with name and role
            VStack(spacing: 2) {
                Text(card.name)
                    .font(CardElements.customFont(name: card.style.fontName, size: 18, weight: .medium))
                    .foregroundColor(.black)
                
                if let role = card.role {
                    Text(role)
                        .font(CardElements.customFont(name: card.style.fontName, size: 16))
                        .foregroundColor(.black)
                }
            }
            .padding(0)  // No extra padding
            
            // Info button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                }
            }
        }
        // Fixed height to match the example
        .frame(maxHeight: .infinity)
        .clipShape(Rectangle())  // Clip to prevent overflow
    }
    
    func backContent() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                )
    
            VStack {
                if let company = card.company {
                    Text(company.uppercased())
                        .font(CardElements.customFont(name: card.style.fontName, size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 80)
                }
    
                Spacer()
    
                // Position the main content much lower, closer to the bottom of the card
                VStack(spacing: 0) {
                    // Main content with social icons and contact info side by side
                    HStack(alignment: .center, spacing: 16) {
                        // Left column: Social Media Icons and username
                        VStack(alignment: .center, spacing: 8) {
                            // Social Media Icons in gray circles in a row
                            HStack(spacing: 5) {
                                socialIcon(text: "in")
                                socialIcon(text: "ig")
                                socialIcon(text: "X")
                                socialIcon(text: "OF")
                            }
                            
                            Text("@username")
                                .font(CardElements.customFont(name: card.style.fontName, size: 12))
                                .foregroundColor(.black)
                        }
                        
                        // Vertical divider - only slightly taller than the icons
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: 50)
                        
                        // Right column: Contact details left-aligned
                        VStack(alignment: .leading, spacing: 5) {
                            contactItem(text: card.contactInformation.websiteURL?.absoluteString ?? "www.website.com")
                            contactItem(text: card.contactInformation.email ?? "company@email.com")
                            contactItem(text: card.contactInformation.phoneNumber ?? "1076-14734920")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            }
    
            // Info Button
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
    
    private func contactItem(text: String) -> some View {
        Text(text)
            .font(CardElements.customFont(name: card.style.fontName, size: 12))
            .foregroundColor(.black)
    }
}

/// Traditional card design implementation
struct TraditionalCardDesign: CardContentDesign {
    let card: Card
    let showInfoAction: () -> Void
    
    func frontContent() -> some View {
        ZStack {
            Rectangle()
                .fill(card.style.primaryColor)
            
            VStack {
                HStack(alignment: .top) {
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        HStack {
                            if let company = card.company {
                                Text(company)
                                    .font(CardElements.customFont(name: card.style.fontName, size: 12))
                                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            }
                            
                            if let role = card.role {
                                Text("| \(role)")
                                    .font(CardElements.customFont(name: card.style.fontName, size: 12))
                                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            }
                        }
                        
                        // Logo (first logo from the array)
                        CardElements.logo(
                            logos: card.logos,
                            color: card.style.secondaryColor,
                            shape: .oval,
                            width: 95,
                            height: 50,
                            contentWidth: 85,
                            contentHeight: 40
                        )
                    }
                }
                
                Spacer()
                
                Text(card.name)
                    .font(CardElements.customFont(name: card.style.fontName, size: 32, weight: .black))
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    CardElements.infoButton(card: card, action: showInfoAction)
                }
            }
            .padding()
        }
    }
    
    func backContent() -> some View {
        ZStack {
            Rectangle()
                .fill(card.style.primaryColor.opacity(0.15))
            
            VStack {
                // Website URL at top right
                HStack {
                    Spacer()
                    if let website = card.contactInformation.websiteURL?.absoluteString {
                        Text(website)
                            .font(CardElements.customFont(name: card.style.fontName, size: 12))
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            .italic()
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                
                Spacer()
                
                // Three logos from the logos array
                VStack(spacing: -10) {
                    HStack(spacing: 50) {
                        // Logo 1 - index 0
                        CardElements.logo(
                            index: 0,
                            logos: card.logos,
                            color: card.style.secondaryColor,
                            shape: .oval,
                            width: 95,
                            height: 50,
                            contentWidth: 85,
                            contentHeight: 40
                        )
                        
                        // Logo 2 - index 1
                        CardElements.logo(
                            index: 1,
                            logos: card.logos,
                            color: card.style.secondaryColor,
                            shape: .oval,
                            width: 95,
                            height: 50,
                            contentWidth: 85,
                            contentHeight: 40
                        )
                    }
                    
                    // Logo 3 - index 2
                    CardElements.logo(
                        index: 2,
                        logos: card.logos,
                        color: card.style.secondaryColor,
                        shape: .oval,
                        width: 95,
                        height: 50,
                        contentWidth: 85,
                        contentHeight: 40
                    )
                }
                
                Spacer()
                
                // Contact information
                VStack(alignment: .trailing, spacing: CardDesign.Padding.small) {
                    if let phone = card.contactInformation.phoneNumber {
                        Text(phone)
                            .font(CardElements.customFont(name: card.style.fontName, size: 12))
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            .italic()
                    }
                    
                    if let linkedIn = card.contactInformation.linkedInURL?.absoluteString {
                        Text(linkedIn)
                            .font(CardElements.customFont(name: card.style.fontName, size: 12))
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            .italic()
                    }
                    
                    if let email = card.contactInformation.email {
                        Text(email)
                            .font(CardElements.customFont(name: card.style.fontName, size: 12))
                            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
                            .italic()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
            VStack {
                Spacer()
                HStack {
                    CardElements.infoButton(card: card, action: showInfoAction)
                        .padding(.leading)
                    Spacer()
                }
            }
            .padding(.bottom)
        }
    }
}



struct CardInfoSheet: View {
    let card: Card
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: CardDesign.Padding.large) {
                cardHeader
                
                if card.contactInformation.hasAnyInformation {
                    contactSection
                }

                if let address = card.businessAddress, address.hasAddressInformation {
                    addressSection(address)
                }

                collectionDataSection
                
                Spacer(minLength: CardDesign.Padding.large)
            }
            .padding(CardDesign.Padding.standard)
        }
        .safeAreaInset(edge: .bottom) {
            closeButton
        }
        .background(Color(.systemBackground))
    }
    
    private var cardHeader: some View {
        VStack(alignment: .leading, spacing: CardDesign.Padding.small) {
            Text(card.name)
                .font(CardElements.customFont(name: card.style.fontName, size: 20, weight: .bold))
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            
            if let title = card.title {
                Text(title)
                    .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .medium))
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.secondary)
            }
            
            if let company = card.company {
                Text(company)
                    .font(CardElements.customFont(name: card.style.fontName, size: 14))
                    .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }
        }
        .padding(.bottom, CardDesign.Padding.small)
    }
    
    private var contactSection: some View {
        Group {
            Text("Contact Information")
                .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .semibold))
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

            VStack(alignment: .leading, spacing: CardDesign.Padding.medium - 2) {
                contactItem(icon: "envelope", text: card.contactInformation.email)
                contactItem(icon: "phone", text: card.contactInformation.phoneNumber)
                contactItem(icon: "printer", text: card.contactInformation.faxNumber)
                
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
    
    private func contactItem(icon: String, text: String?) -> some View {
        Group {
            if let text = text {
                HStack(alignment: .top) {
                    Image(systemName: icon)
                        .frame(width: 20)
                    Text(text)
                        .font(CardElements.customFont(name: card.style.fontName, size: 14))
                }
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
            }
        }
    }
    
    private func addressSection(_ address: Address) -> some View {
        Group {
            Text("Business Address")
                .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .semibold))
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

            HStack(alignment: .top) {
                Image(systemName: "building")
                    .frame(width: 20)
                Text(address.formattedAddress ?? "")
                    .font(CardElements.customFont(name: card.style.fontName, size: 14))
                    .multilineTextAlignment(.leading)
            }
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

            divider
        }
    }
    
    private var collectionDataSection: some View {
        Group {
            Text("Collection Data")
                .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .semibold))
                .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

            HStack(alignment: .top) {
                Image(systemName: "calendar")
                    .frame(width: 20)
                Text(card.collectionDate.formatted(date: .long, time: .shortened))
                    .font(CardElements.customFont(name: card.style.fontName, size: 14))
            }
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)

            HStack(alignment: .top) {
                Image(systemName: "mappin.and.ellipse")
                    .frame(width: 20)
                Text("\(card.collectionLocation.latitude, specifier: "%.4f"), \(card.collectionLocation.longitude, specifier: "%.4f")")
                    .font(CardElements.customFont(name: card.style.fontName, size: 14))
            }
            .foregroundColor(card.style.secondaryColor ?? CardDesign.Colors.primary)
        }
    }
    
    private var divider: some View {
        Divider()
            .background(card.style.secondaryColor?.opacity(0.5) ?? Color.gray.opacity(0.5))
            .padding(.vertical, CardDesign.Padding.small)
    }
    
    private var closeButton: some View {
        Button(action: { isPresented = false }) {
            Text("Close")
                .font(CardElements.customFont(name: card.style.fontName, size: 16, weight: .medium))
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
