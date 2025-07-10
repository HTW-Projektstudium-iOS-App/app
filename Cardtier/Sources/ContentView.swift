import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Image(asset: CardtierImages(name: "Background Gradient"))
        .resizable()
        .ignoresSafeArea()

      HomeView()
    }
  }
}

#Preview {
  ContentView()
}
