import SwiftUI

/// Main content view displaying the card stack and focused card overlay.
public struct ContentView: View {
    @StateObject private var viewModel = CardStackViewModel(withSampleData: true)
    @State private var scrollReader: ScrollViewProxy? = nil

    // Spring animation for stack transitions
    private let stackAnimation = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3)

    public init() {}

    public var body: some View {
        ZStack(alignment: .top) {
            // Card stack with scroll control
            CardStackView(scrollReader: $scrollReader)
            // Overlay for focused card details
            FocusedCardView()
        }
        .background(Color(UIColor.systemGroupedBackground))
        // Scroll to top when a card is focused
        .onChange(of: viewModel.focusedCardID) { oldValue, newValue in
            if newValue != nil {
                withAnimation(stackAnimation) {
                    scrollReader?.scrollTo("stackAnchor", anchor: .top)
                }
            }
        }
        .environmentObject(viewModel)
    }
}
