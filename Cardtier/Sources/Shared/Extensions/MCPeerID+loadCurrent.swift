import MultipeerConnectivity
import UIKit

extension MCPeerID {
  static func loadCurrent() -> MCPeerID {
    let key = "com.myapp.peerID.displayName"
    let defaults = UserDefaults.standard

    if let savedName = defaults.string(forKey: key) {
      return MCPeerID(displayName: savedName)
    }

    let deviceName = UIDevice.current.name
    let suffix = UUID().uuidString.prefix(5)
    let display = "\(deviceName)-\(suffix)"
    defaults.set(display, forKey: key)

    return MCPeerID(displayName: display)
  }
}
