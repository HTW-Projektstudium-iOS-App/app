import SwiftUI
import CoreLocation

// MARK: - Card Model
/// Represents a single card with front/back text, date, and location.
struct Card: Identifiable {
    let id: UUID
    let frontText: String
    let backText: String
    let collectionDate: Date
    let collectionLocation: CLLocationCoordinate2D
}

// MARK: - CardView
/// Displays a single card, handles flipping, focus, and info sheet logic.
struct CardView: View {
    let card: Card
    @Binding var isFlipped: Bool
    @Binding var showInfo: Bool
    @Binding var focusedCardID: UUID?

    var body: some View {
        ZStack {
            // Card background with shadow
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.white)
                .shadow(radius: 4)
                .frame(height: 180)
                .overlay(
                    VStack(alignment: .leading) {
                        // Show back or front text depending on flip state
                        if isFlipped {
                            Text(card.backText)
                                .font(.title2)
                                .foregroundColor(.secondary)
                        } else {
                            Text(card.frontText)
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            // Info button
                            Button(action: {
                                showInfo = true
                            }) {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                )
        }
        // Tap: If focused, flip card. If not, set as focused.
        .onTapGesture {
            if focusedCardID == card.id {
                withAnimation { isFlipped.toggle() }
            } else {
                withAnimation { focusedCardID = card.id }
            }
        }
        // Reset flip state if focus changes to another card
        .onChange(of: focusedCardID) { oldID, newID in
            if newID != card.id {
                isFlipped = false
            }
        }
        // Info sheet with metadata
        .sheet(isPresented: $showInfo) {
            VStack(spacing: 20) {
                Text("Card Metadata")
                    .font(.headline)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Collection Date:")
                        .font(.subheadline)
                        .bold()
                    Text(card.collectionDate.formatted(date: .long, time: .shortened))
                        .font(.body)
                    Divider()
                    Text("Collection Location:")
                        .font(.subheadline)
                        .bold()
                    Text("Lat: \(card.collectionLocation.latitude, specifier: "%.4f")")
                    Text("Lon: \(card.collectionLocation.longitude, specifier: "%.4f")")
                }
                Spacer()
                Button("Close") {
                    showInfo = false
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

// MARK: - ContentView
/// Main view: shows a vertical stack of cards with focus and flip logic.
public struct ContentView: View {
    // State for each card: flipped, info shown, etc.
    @State private var flipped: [UUID: Bool] = [:]
    @State private var showInfo: [UUID: Bool] = [:]
    // List of all cards
    @State private var cards: [Card] = [
        Card(id: UUID(), frontText: "John Doe", backText: "Acme Corp\nProduct Manager", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)),
        Card(id: UUID(), frontText: "Jane Smith", backText: "Tech Solutions\nSoftware Engineer", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)),
        Card(id: UUID(), frontText: "Alice Johnson", backText: "Global Industries\nData Scientist", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)),
        Card(id: UUID(), frontText: "Bob Brown", backText: "Innovatech\nUX Designer", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
        Card(id: UUID(), frontText: "Charlie Green", backText: "Future Tech\nAI Researcher", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)),
        Card(id: UUID(), frontText: "Diana White", backText: "Health Solutions\nProduct Owner", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        Card(id: UUID(), frontText: "Ethan Black", backText: "Finance Corp\nInvestment Analyst", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)),
        Card(id: UUID(), frontText: "Fiona Blue", backText: "Eco Innovations\nSustainability Expert", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)),
        Card(id: UUID(), frontText: "George Yellow", backText: "Retail Group\nMarketing Director", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)),
        Card(id: UUID(), frontText: "Hannah Purple", backText: "Travel Agency\nOperations Manager", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)),
        Card(id: UUID(), frontText: "Ian Orange", backText: "Media Corp\nContent Strategist", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 45.4215, longitude: -75.6972)),
        Card(id: UUID(), frontText: "Julia Pink", backText: "Education Services\nCurriculum Developer", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 55.9533, longitude: -3.1883)),
        Card(id: UUID(), frontText: "Kevin Gray", backText: "Construction Co\nProject Manager", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603)),
    ]
    // Which card is currently focused (in front)
    @State private var focusedCardID: UUID? = nil
    // For scroll handling
    @State private var selectedCardIndex: Int? = nil
    @State private var lastScrollOffset: CGFloat = 0
    @State private var isScrolling = false
    public init() {}

    public var body: some View {
        // Get the currently focused card, if any
        let focusedCard = focusedCardID.flatMap { id in cards.first(where: { $0.id == id }) }

        ZStack(alignment: .top) {
            // Scrollable list of cards (not focused)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                        if card.id != focusedCardID {
                            CardView(
                                card: card,
                                isFlipped: Binding(
                                    get: { flipped[card.id] ?? false },
                                    set: { flipped[card.id] = $0 }
                                ),
                                showInfo: Binding(
                                    get: { showInfo[card.id] ?? false },
                                    set: { showInfo[card.id] = $0 }
                                ),
                                focusedCardID: $focusedCardID
                            )
                            .frame(height: 180)
                            .padding(.horizontal, 20)
                            .zIndex(Double(index))
                            // Stack cards visually
                            .offset(y: CGFloat(index) * -120)
                        }
                    }
                }
                .padding(.top, 260)
                // Track scroll offset for focus reset
                .background(GeometryReader { geo in
                    Color.clear
                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                })
            }
            // Allow tap to unfocus even when a card is focused, without blocking scroll
            .simultaneousGesture(
                TapGesture().onEnded {
                    if focusedCardID != nil {
                        focusedCardID = nil
                        flipped = [:]
                        showInfo = [:]
                    }
                }
            )
            // As soon as user drags (scrolls), remove focus and reset all cards
            .gesture(
                DragGesture(minimumDistance: 5)
                    .onChanged { _ in
                        if focusedCardID != nil {
                            focusedCardID = nil
                            flipped = [:]
                            showInfo = [:]
                        }
                    }
            )
            .coordinateSpace(name: "scroll")
            // When scroll offset changes, reset focus and flip state (fallback)
            .onPreferenceChange(ScrollOffsetKey.self) { newOffset in
                if abs(newOffset - lastScrollOffset) > 5 {
                    focusedCardID = nil
                    flipped = [:]
                    showInfo = [:]
                }
                lastScrollOffset = newOffset
            }

            // Show the focused card on top, centered
            if let card = focusedCard {
                CardView(
                    card: card,
                    isFlipped: Binding(
                        get: { flipped[card.id] ?? false },
                        set: { flipped[card.id] = $0 }
                    ),
                    showInfo: Binding(
                        get: { showInfo[card.id] ?? false },
                        set: { showInfo[card.id] = $0 }
                    ),
                    focusedCardID: $focusedCardID
                )
                .frame(height: 180)
                .padding(.horizontal, 20)
                .zIndex(1000)
                .padding(.top, 20) // Fixed position below status bar
                .transition(.identity)
                .animation(.easeInOut, value: focusedCardID)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

// MARK: - ScrollOffsetKey
/// Used to track the scroll position in the ScrollView.
private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
