import SwiftUI

@main
struct CardtierApp: App {
  @StateObject private var cardExchangeService = CardExchangeService()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(cardExchangeService)
    }
    .modelContainer(for: Card.self)
  }
}
