import SwiftUI
import CoreLocation

// MARK: - Constants
private enum Constants {
    static let cardHeight: CGFloat = 180
    static let cardStackOffset: CGFloat = -120
    static let focusedCardTopPadding: CGFloat = 20
    static let horizontalPadding: CGFloat = 20
    static let stackTopPadding: CGFloat = 260
    static let dragMinDistance: CGFloat = 1
}

// MARK: - Card Model
struct Card: Identifiable {
    let frontText: String
    let id: UUID
    let backText: String
    let collectionDate: Date
    let collectionLocation: CLLocationCoordinate2D
}

// MARK: - CardView
struct CardView: View {
    let card: Card
    @Binding var isFlipped: Bool
    @Binding var showInfo: Bool
    @Binding var focusedCardID: UUID?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.white)
                .shadow(radius: 4)
                .frame(height: Constants.cardHeight)
                .overlay(
                    VStack(alignment: .leading) {
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
        .onTapGesture {
            if focusedCardID == card.id {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.7)) {
                    isFlipped.toggle()
                }
            } else {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.7)) {
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
public struct ContentView: View {
    // MARK: - Properties
    @State private var flipped: [UUID: Bool] = [:]
    @State private var showInfo: [UUID: Bool] = [:]
    @State private var cards: [Card] = [
        Card(frontText: "John Doe", id: UUID(), backText: "Acme Corp\nProduct Manager", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)),
        Card(frontText: "Jane Smith", id: UUID(), backText: "Tech Solutions\nSoftware Engineer", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)),
        Card(frontText: "Alice Johnson", id: UUID(), backText: "Global Industries\nData Scientist", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)),
        Card(frontText: "Bob Brown", id: UUID(), backText: "Innovatech\nUX Designer", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
        Card(frontText: "Charlie Green", id: UUID(), backText: "Future Tech\nAI Researcher", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)),
        Card(frontText: "Diana White", id: UUID(), backText: "Health Solutions\nProduct Owner", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
        Card(frontText: "Ethan Black", id: UUID(), backText: "Finance Corp\nInvestment Analyst", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)),
        Card(frontText: "Fiona Blue", id: UUID(), backText: "Eco Innovations\nSustainability Expert", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074)),
        Card(frontText: "George Yellow", id: UUID(), backText: "Retail Group\nMarketing Director", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)),
        Card(frontText: "Hannah Purple", id: UUID(), backText: "Travel Agency\nOperations Manager", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)),
        Card(frontText: "Ian Orange", id: UUID(), backText: "Media Corp\nContent Strategist", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 45.4215, longitude: -75.6972)),
        Card(frontText: "Julia Pink", id: UUID(), backText: "Education Services\nCurriculum Developer", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 55.9533, longitude: -3.1883)),
        Card(frontText: "Kevin Gray", id: UUID(), backText: "Construction Co\nProject Manager", collectionDate: Date(), collectionLocation: CLLocationCoordinate2D(latitude: 53.3498, longitude: -6.2603)),
    ]
    @State private var focusedCardID: UUID? = nil
    @State private var isDragging = false
    
    private var focusAnimation: Animation {
        .spring(response: 0.3, dampingFraction: 0.7)
    }

    public init() {}
    
    // MARK: - Helper Methods
    private func bindingForCard<T>(_ card: Card, from dictionary: Binding<[UUID: T]>, defaultValue: T) -> Binding<T> {
        Binding(
            get: { dictionary.wrappedValue[card.id] ?? defaultValue },
            set: { dictionary.wrappedValue[card.id] = $0 }
        )
    }
    
    private func resetFocusedCard() {
        withAnimation(focusAnimation) {
            focusedCardID = nil
            flipped = [:]
            showInfo = [:]
        }
    }

    // MARK: - Body
    public var body: some View {
        let focusedCard = focusedCardID.flatMap { id in cards.first(where: { $0.id == id }) }

        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    // Transparent overlay for tap-to-reset (only on empty stack area)
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if focusedCardID != nil {
                                resetFocusedCard()
                            }
                        }
                    VStack(spacing: 0) {
                        ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                            if card.id != focusedCardID {
                                CardView(
                                    card: card,
                                    isFlipped: bindingForCard(card, from: $flipped, defaultValue: false),
                                    showInfo: bindingForCard(card, from: $showInfo, defaultValue: false),
                                    focusedCardID: $focusedCardID
                                )
                                .frame(height: Constants.cardHeight)
                                .padding(.horizontal, Constants.horizontalPadding)
                                .zIndex(Double(index))
                                .offset(y: CGFloat(index) * Constants.cardStackOffset)
                            }
                        }
                    }
                    .padding(.top, Constants.stackTopPadding)
                }
            }
            // Detect scrolling with gesture
            .simultaneousGesture(
                DragGesture(minimumDistance: Constants.dragMinDistance, coordinateSpace: .local)
                    .onChanged { _ in
                        if !isDragging && focusedCardID != nil {
                            isDragging = true
                            resetFocusedCard()
                        }
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )

            if let card = focusedCard {
                CardView(
                    card: card,
                    isFlipped: bindingForCard(card, from: $flipped, defaultValue: false),
                    showInfo: bindingForCard(card, from: $showInfo, defaultValue: false),
                    focusedCardID: $focusedCardID
                )
                .frame(height: Constants.cardHeight)
                .padding(.horizontal, Constants.horizontalPadding)
                .zIndex(1000)
                .padding(.top, Constants.focusedCardTopPadding)
                .transition(.identity)
                .animation(focusAnimation, value: focusedCardID)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
