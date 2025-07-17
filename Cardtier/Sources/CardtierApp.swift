import SwiftData
import SwiftUI

@main
struct CardtierApp: App {
  @StateObject private var cardExchangeService = CardExchangeService()

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(cardExchangeService)
        .modelContainer(for: Card.self)
    }
  }

}

struct RootView: View {
  @Environment(\.modelContext) private var modelContext

  @State private var isReady = false

  var body: some View {
    ZStack {
      ContentView()

      if !isReady {
        LaunchScreen()
          .transition(.move(edge: .bottom).combined(with: .opacity))
          .zIndex(1)
          .task { await setup() }
      }
    }
    .animation(.easeInOut(duration: 0.5), value: isReady)
  }

  private func setup() async {
    try? await Task.sleep(for: .seconds(1.5))

    let fetch = FetchDescriptor<Card>()
    let count = (try? modelContext.fetchCount(fetch)) ?? 0
    guard count == 0 else {
      isReady = true
      return
    }

    modelContext.insert(Card.sampleUserCard)
    Card.sampleCards.forEach { card in
      modelContext.insert(card)
    }

    try? modelContext.save()

    withAnimation {
      isReady = true
    }
  }
}

struct LaunchScreen: View {
  var body: some View {
    GeometryReader { geo in
      ZStack {
        Image("Background Gradient")
          .resizable()
          .scaledToFill()
          .ignoresSafeArea()
          .frame(
            width: geo.size.width,
            height: geo.size.height)

        Image("logo")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 346, height: 127)
          .position(
            x: 23 + 346 / 2,
            y: 253 + 127 / 2
          )
      }
    }
  }
}
