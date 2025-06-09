// Sources/Cardtier/Views/CardView.swift
import SwiftUI

/// Displays a single business card that can be flipped and shows metadata
public struct CardView: View {
    /// The card data to display
    let card: Card
    
    /// Whether the card is currently flipped to show back side
    @Binding var isFlipped: Bool
    
    /// Whether the metadata sheet is displayed
    @Binding var showInfo: Bool
    
    /// ID of the currently focused card (if any)
    @Binding var focusedCardID: UUID?

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
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.white) // Keep cards white regardless of dark mode
                .shadow(radius: 4)
                .frame(height: CardDesign.Layout.cardHeight)
                .overlay(
                    VStack(alignment: .leading) {
                        if isFlipped {
                            Text(card.backText)
                                .font(.title2)
                                .foregroundColor(.black) // Explicit dark color for text
                        } else {
                            Text(card.frontText)
                                .font(.title)
                                .foregroundColor(.black) // Explicit dark color for text
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                                    .foregroundColor(.black) // Explicit dark color for icon
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                )
        }
        .onTapGesture {
            if focusedCardID == card.id {
                withAnimation(CardDesign.Animation.focusTransition) {
                    isFlipped.toggle()
                }
            } else {
                withAnimation(CardDesign.Animation.focusTransition) {
                    focusedCardID = card.id
                }
            }
        }
        .onChange(of: focusedCardID) { oldID, newID in
            if newID != card.id {
                isFlipped = false
            }
        }
        .sheet(isPresented: $showInfo) {
            CardInfoSheet(card: card, isPresented: $showInfo)
        }
    }
}

/// Sheet displaying metadata about a business card
private struct CardInfoSheet: View {
    /// The card to display information for
    let card: Card
    
    /// Binding to control sheet presentation
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Card Metadata")
                .font(.headline)
                .foregroundColor(Color(UIColor.label))
            VStack(alignment: .leading, spacing: 8) {
                Text("Collection Date:")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                Text(card.collectionDate.formatted(date: .long, time: .shortened))
                    .font(.body)
                    .foregroundColor(Color(UIColor.label))
                Divider()
                Text("Collection Location:")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color(UIColor.label))
                Text("Lat: \(card.collectionLocation.latitude, specifier: "%.4f")")
                    .foregroundColor(Color(UIColor.label))
                Text("Lon: \(card.collectionLocation.longitude, specifier: "%.4f")")
                    .foregroundColor(Color(UIColor.label))
            }
            Spacer()
            Button("Close") {
                isPresented = false
            }
            .padding(.top)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}
