import SwiftUI

@main
struct CardtierApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: Card.self)
  }
}
