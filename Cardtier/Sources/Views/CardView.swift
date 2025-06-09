// Sources/Cardtier/Views/CardView.swift
import SwiftUI

/// Defines different card presentation styles
/// Each style represents a specific card design for front and back sides
public enum CardDesignStyle {
    case modernFront   // Modern design for the front side
    case modernBack    // Modern design for the back side
    case minimalFront  // Minimal design for the front side
    case minimalBack   // Minimal design for the back side
    // More styles can be added here for future design options
}

/// Displays a single business card that can be flipped and shows metadata
/// This view handles the main card presentation, animations, and interactions
public struct CardView: View {
    /// The card data model containing all business card information
    let card: Card
    
    /// Whether the card is currently flipped to show back side
    /// True = showing back side, False = showing front side
    @Binding var isFlipped: Bool
    
    /// Whether the detailed metadata sheet is currently displayed
    @Binding var showInfo: Bool
    
    /// ID of the currently focused/selected card (if any)
    /// When a card is focused, it receives visual emphasis and interaction focus
    @Binding var focusedCardID: UUID?
    
    /// Animation for card flipping transitions
    /// Spring animation provides natural, physical feel to the flip
    private let flipAnimation = Animation.spring(response: 0.5, dampingFraction: 0.7)
    
    /// Animation for card selection/deselection
    /// Slightly different timing than flip animation for better UX
    private let selectionAnimation = Animation.spring(response: 0.6, dampingFraction: 0.75)
    
    /// Determines if this specific card is currently focused
    /// Compares this card's ID with the focused card ID
    private var isFocused: Bool {
        focusedCardID == card.id
    }
    
    /// Determines if any card in the collection is currently focused
    /// Used to apply visual changes to non-focused cards
    private var isAnyCardFocused: Bool {
        focusedCardID != nil
    }
    
    /// Additional vertical offset for non-focused cards when a card is selected
    /// Creates a "stack collapse" effect where unfocused cards move down
    private var stackCollapseOffset: CGFloat {
        isAnyCardFocused && !isFocused ? 100 : 0
    }

    /// Creates a new card view
    /// - Parameters:
    ///   - card: The card data to display
    ///   - isFlipped: Binding to track if card is showing back side
    ///   - showInfo: Binding to track if metadata sheet is visible
    ///   - focusedCardID: Binding to the currently focused card ID
    public init(
        card: Card,
        isFlipped: Binding<Bool>,
        showInfo: Binding<Bool>,
        focusedCardID: Binding<UUID?>
    ) {
        self.card = card
        self._isFlipped = isFlipped
        self._showInfo = showInfo
        self._focusedCardID = focusedCardID
    }
    
    /// Determines the appropriate CardDesignStyle based on the card's style property
    /// - Parameter isFront: Whether this is for the front side of the card
    /// - Returns: The corresponding CardDesignStyle
    private func designStyleForCard(isFront: Bool) -> CardDesignStyle {
        switch card.style.designStyle {
        case .modern:
            return isFront ? .modernFront : .modernBack
        case .minimal:
            return isFront ? .minimalFront : .minimalBack
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            // Calculate card size based on available width (95% of screen width, max 500pt)
            // Maintains 16:10 aspect ratio for business card standard format
            let cardWidth = min(geometry.size.width * 0.95, 500)
            let cardHeight = cardWidth / 1.6 // 16:10 aspect ratio
            
            ZStack {
                // Front side of the card - using style from card model
                // Becomes invisible and rotates when flipped
                cardFace(style: designStyleForCard(isFront: true))
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.3
                    )
                
                // Back side of the card - using style from card model
                // Becomes visible and rotates into view when flipped
                cardFace(style: designStyleForCard(isFront: false))
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(isFlipped ? 0 : -180),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.3
                    )
            }
            .frame(width: cardWidth, height: cardHeight)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center in container
            .scaleEffect(isFocused ? 1.05 : 1.0) // Slightly enlarge focused card
            .blur(radius: isAnyCardFocused && !isFocused ? 1.5 : 0) // Blur unfocused cards
            .brightness(isAnyCardFocused ? (isFocused ? 0.03 : -0.05) : 0) // Adjust brightness for focus state
            .offset(y: stackCollapseOffset) // Move unfocused cards down
            .onTapGesture {
                if isFocused {
                    // If already focused, flip the card
                    withAnimation(flipAnimation) {
                        isFlipped.toggle()
                    }
                } else {
                    // If not focused, make this card the focused one
                    withAnimation(selectionAnimation) {
                        focusedCardID = card.id
                    }
                }
            }
            .onChange(of: focusedCardID) { oldID, newID in
                // Reset flip state when focus changes to a different card
                if newID != card.id {
                    isFlipped = false
                }
            }
            .sheet(isPresented: $showInfo) {
                // Display detailed info sheet when showInfo is true
                CardInfoSheet(card: card, isPresented: $showInfo)
            }
        }
    }
    
    /// Creates a card face with the specified style
    /// Includes styling like background, shadow, and content based on design style
    private func cardFace(style: CardDesignStyle) -> some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color.white) // White background for card
            .shadow(radius: isFocused ? 8 : 4, x: 0, y: isFocused ? 4 : 2) // Enhanced shadow for focused cards
            .overlay(
                cardContentForStyle(style) // Content differs based on card style
            )
            .overlay(
                Rectangle()
                    .fill(Color.black.opacity(isAnyCardFocused && !isFocused ? 0.15 : 0)) // Dim unfocused cards
            )
    }
    
    /// Returns the appropriate content view for the given card style
    /// Each style is implemented as a separate view component for modularity
    @ViewBuilder
    private func cardContentForStyle(_ style: CardDesignStyle) -> some View {
        switch style {
        case .modernFront:
            ModernFrontCardContent(card: card, showInfoAction: { showInfo = true })
        case .modernBack:
            ModernBackCardContent(card: card, showInfoAction: { showInfo = true })
        case .minimalFront:
            MinimalFrontCardContent(card: card, showInfoAction: { showInfo = true })
        case .minimalBack:
            MinimalBackCardContent(card: card, showInfoAction: { showInfo = true })
        }
    }
}

/// Modern design for front card face
/// Features name, title, and company with left-aligned layout
private struct ModernFrontCardContent: View {
    let card: Card // Card data to display
    let showInfoAction: () -> Void // Action to show detailed info sheet
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 20) // Top margin
            
            // Main information section
            VStack(alignment: .leading, spacing: 4) {
                // Name is always displayed prominently
                Text(card.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.black)
                
                // Title (job position) if available
                if let title = card.title {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                
                // Company name if available
                if let company = card.company {
                    Text(company)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.top, 2)
                }
            }
            
            Spacer() // Push content to top
            
            // Info button in bottom right corner
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding() // Padding around all content
    }
}

/// Modern design for back card face
/// Features contact information, address, and slogan with left-aligned layout
private struct ModernBackCardContent: View {
    let card: Card // Card data to display
    let showInfoAction: () -> Void // Action to show detailed info sheet
    
    var body: some View {
        VStack(alignment: .leading) {
            // Information section with company, role, contact info
            VStack(alignment: .leading, spacing: 6) {
                // Company name if available
                if let company = card.company {
                    Text(company)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                // Role/department if available
                if let role = card.role {
                    Text(role)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Contact information (email, phone) if available
                if card.contactInformation.hasAnyInformation {
                    VStack(alignment: .leading, spacing: 4) {
                        if let email = card.contactInformation.email {
                            Text(email)
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                        
                        if let phone = card.contactInformation.phoneNumber {
                            Text(phone)
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.top, 4)
                }
                
                // Business address if available
                if let address = card.businessAddress?.formattedAddress {
                    Text(address)
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.top, 2)
                }
                
                // Company slogan/tagline if available
                if let slogan = card.slogan {
                    Text("\"\(slogan)\"")
                        .font(.caption)
                        .italic()
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
            }
            
            Spacer() // Push content to top
            
            // Info button in bottom right corner
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding() // Padding around all content
    }
}

/// Minimal design for front card face
/// Simplified, centered layout with just name and title
private struct MinimalFrontCardContent: View {
    let card: Card // Card data to display
    let showInfoAction: () -> Void // Action to show detailed info sheet
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer() // Push content to center
            
            // Name is always displayed prominently
            Text(card.name)
                .font(.title3)
                .bold()
                .foregroundColor(.black)
            
            // Title (job position) if available
            if let title = card.title {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer() // Push content to center
            
            // Info button in bottom right corner
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding() // Padding around all content
    }
}

/// Minimal design for back card face
/// Simplified, centered layout with company and email only
private struct MinimalBackCardContent: View {
    let card: Card // Card data to display
    let showInfoAction: () -> Void // Action to show detailed info sheet
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer() // Push content to center
            
            // Company name if available
            if let company = card.company {
                Text(company)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            
            // Email if available
            if let email = card.contactInformation.email {
                Text(email)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            
            Spacer() // Push content to center
            
            // Info button in bottom right corner
            HStack {
                Spacer()
                Button(action: showInfoAction) {
                    Image(systemName: "info.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding() // Padding around all content
    }
}

/// Sheet displaying detailed metadata about a business card
/// Appears when user taps info button
private struct CardInfoSheet: View {
    /// The card to display information for
    let card: Card
    
    /// Binding to control sheet presentation
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with name
            Text(card.name)
                .font(.headline)
                .foregroundColor(Color(UIColor.label))

            // Contact information section - only displayed if information exists
            if card.contactInformation.hasAnyInformation {
                Group {
                    Text("Contact Information")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color(UIColor.label))

                    // List of contact details
                    VStack(alignment: .leading, spacing: 6) {
                        if let email = card.contactInformation.email {
                            Text("Email: \(email)")
                                .foregroundColor(Color(UIColor.label))
                        }
                        if let phone = card.contactInformation.phoneNumber {
                            Text("Phone: \(phone)")
                                .foregroundColor(Color(UIColor.label))
                        }
                        if let fax = card.contactInformation.faxNumber {
                            Text("Fax: \(fax)")
                                .foregroundColor(Color(UIColor.label))
                        }
                        if let website = card.contactInformation.websiteURL {
                            Text("Website: \(website.absoluteString)")
                                .foregroundColor(Color(UIColor.label))
                        }
                        if let linkedin = card.contactInformation.linkedInURL {
                            Text("LinkedIn: \(linkedin.absoluteString)")
                                .foregroundColor(Color(UIColor.label))
                        }
                    }
                    Divider() // Visual separator
                }
            }

            // Address information - only displayed if information exists
            if let address = card.businessAddress, address.hasAnyInformation {
                Group {
                    Text("Business Address")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color(UIColor.label))

                    Text(address.formattedAddress ?? "")
                        .foregroundColor(Color(UIColor.label))

                    Divider() // Visual separator
                }
            }

            // Collection metadata - when and where the card was collected
            Group {
                Text("Collection Data")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.label))

                Text("Date: \(card.collectionDate.formatted(date: .long, time: .shortened))")
                    .foregroundColor(Color(UIColor.label))

                Text("Location: \(card.collectionLocation.latitude, specifier: "%.4f"), \(card.collectionLocation.longitude, specifier: "%.4f")")
                    .foregroundColor(Color(UIColor.label))
            }

            Spacer() // Push content to top, button to bottom

            // Close button
            Button("Close") {
                isPresented = false
            }
            .frame(maxWidth: .infinity) // Full width button
            .padding(.vertical, 8)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding() // Padding around all content
        .background(Color(UIColor.systemBackground)) // System background color for light/dark mode
    }
}
