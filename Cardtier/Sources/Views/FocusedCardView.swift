import SwiftUI

/// Overlay view that displays the currently focused card with animation and shadow.
struct FocusedCardView: View {
    @EnvironmentObject private var viewModel: CardStackViewModel

    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            Group {
                // Show only if a card is focused
                if let card = viewModel.focusedCard {
                    CardView(
                        card: card,
                        isFlipped: viewModel.bindingForCard(card, from: \.flipped, defaultValue: false),
                        showInfo: viewModel.bindingForCard(card, from: \.showInfo, defaultValue: false),
                        focusedCardID: $viewModel.focusedCardID
                    )
                    .frame(height: CardDesign.Layout.cardHeight)
                    .padding(.horizontal, CardDesign.Layout.horizontalPadding)
                    .zIndex(FocusedCardViewConstants.zIndex)
                    // Add safe area inset to top padding for consistent spacing below Dynamic Island/notch
                    .padding(.top, CardDesign.Layout.focusedCardTopPadding + safeAreaTop)
                    // Custom transition for appearing/disappearing
                    .transition(
                        .asymmetric(
                            insertion: AnyTransition.opacity
                                .combined(with: .move(edge: .bottom))
                                .animation(.easeOut(duration: FocusedCardViewConstants.insertionDuration)),
                            removal: AnyTransition.opacity
                                .combined(with: .move(edge: .bottom))
                                .animation(.easeIn(duration: FocusedCardViewConstants.removalDuration))
                        )
                    )
                    .shadow(
                        radius: FocusedCardViewConstants.shadowRadius,
                        x: FocusedCardViewConstants.shadowX,
                        y: FocusedCardViewConstants.shadowY
                    )
                    // Subtle 3D tilt for depth
                    .rotation3DEffect(
                        .degrees(FocusedCardViewConstants.rotationDegrees),
                        axis: FocusedCardViewConstants.rotationAxis,
                        anchor: .center,
                        perspective: FocusedCardViewConstants.rotationPerspective
                    )
                    // Animate on focused card change
                    .animation(FocusedCardViewConstants.stackAnimation, value: viewModel.focusedCardID)
                }
            }
        }
    }
}
