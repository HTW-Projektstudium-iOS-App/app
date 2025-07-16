import SwiftUI

@main
struct CardtierApp: App {
  @StateObject private var multipeerManager = MultipeerManager()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(multipeerManager)
    }
    .modelContainer(for: Card.self)
  }
}
