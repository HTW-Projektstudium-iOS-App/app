import Combine
import Foundation
import MultipeerConnectivity
import NearbyInteraction
import os

class CardExchangeService: NSObject, ObservableObject {
  private let serviceType = "htw-cardtier"
  private let localPeerID = MCPeerID.loadCurrent()

  private var cancellables = Set<AnyCancellable>()

  private var encoder = JSONEncoder()
  private var decoder = JSONDecoder()

  private var session: MCSession!
  private var advertiser: MCNearbyServiceAdvertiser!
  private var browser: MCNearbyServiceBrowser!

  private var niSession: NISession!
  private var peerDiscoveryTokens: [MCPeerID: NIDiscoveryToken] = [:]

  @Published private var distances: [MCPeerID: Float] = [:]
  @Published var closestPeer: (peer: MCPeerID, distance: Float)?

  var onCardReceived: ((Card) -> Void)?

  override init() {
    super.init()

    session = MCSession(
      peer: localPeerID,
      securityIdentity: nil,
      encryptionPreference: .required)
    session.delegate = self

    advertiser = MCNearbyServiceAdvertiser(
      peer: localPeerID,
      discoveryInfo: nil,
      serviceType: serviceType)
    advertiser.delegate = self
    advertiser.startAdvertisingPeer()

    browser = MCNearbyServiceBrowser(
      peer: localPeerID,
      serviceType: serviceType)
    browser.delegate = self
    browser.startBrowsingForPeers()

    niSession = NISession()
    niSession.delegate = self

    $distances
      .compactMap { $0.min(by: { $0.value < $1.value }) }
      .map { (peer: $0.key, distance: $0.value) }
      .assign(to: \.closestPeer, on: self)
      .store(in: &cancellables)
  }

  func sendCard(_ card: Card, to peer: MCPeerID) {
    if let data = try? encoder.encode(CardDTO(from: card)) {
      try? session.send(data, toPeers: [peer], with: .reliable)

      print("Sent card: \(card.id) to peer: \(peer.displayName)")
    }
  }
}

// MARK: - Multipeer Connectivity

extension CardExchangeService: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    if state == .connected {
      self.sendDiscoveryToken(to: peerID)
    }
  }

  // Receive either a discovery token or a card
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    let token = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data)

    if let token {
      print("Received discovery token from peer: \(peerID.displayName)")

      peerDiscoveryTokens[peerID] = token
      setupNearbyInteraction(with: token)
      return
    }

    let cardData = try? decoder.decode(CardDTO.self, from: data)
    if let cardData {
      print("Received card from peer: \(peerID.displayName)")

      let card = cardData.createCard()
      DispatchQueue.main.async {
        self.onCardReceived?(card)
      }
    }
  }

  func session(_: MCSession, didReceive _: InputStream, withName _: String, fromPeer _: MCPeerID) {}
  func session(
    _: MCSession, didStartReceivingResourceWithName _: String, fromPeer _: MCPeerID,
    with _: Progress
  ) {}
  func session(
    _: MCSession, didFinishReceivingResourceWithName _: String, fromPeer _: MCPeerID, at _: URL?,
    withError _: Error?
  ) {}
}

// Immediately connect all available peers with each other
extension CardExchangeService: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
  func advertiser(
    _ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void
  ) { invitationHandler(true, session) }

  func browser(
    _ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID,
    withDiscoveryInfo info: [String: String]?
  ) { browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10) }

  func browser(_: MCNearbyServiceBrowser, lostPeer _: MCPeerID) {}
  func advertiser(_: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {}
  func browser(_: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {}
}

// MARK: - Nearby Interaction

extension CardExchangeService: NISessionDelegate {
  func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) {
    for object in nearbyObjects {
      let token = object.discoveryToken
      let peer = peerDiscoveryTokens.first(where: { $0.value == token })?.key

      guard let peer else { continue }
      guard let dist = object.distance else { continue }

      DispatchQueue.main.async { self.distances[peer] = dist }
    }

    func session(_ session: NISession, didInvalidateWith error: Error) {
      print("NISession invalidated: \(error.localizedDescription)")

      peerDiscoveryTokens.removeAll()
      DispatchQueue.main.async { self.distances.removeAll() }
    }

    func sessionWasSuspended(_ session: NISession) {
      print("NISession was suspended")
    }

    func sessionSuspensionEnded(_ session: NISession) {
      print("NISession suspension ended")

      for token in peerDiscoveryTokens.values {
        setupNearbyInteraction(with: token)
      }
    }
  }

  private func sendDiscoveryToken(to peer: MCPeerID) {
    guard let token = niSession.discoveryToken else { return }

    do {
      let data = try NSKeyedArchiver.archivedData(
        withRootObject: token,
        requiringSecureCoding: true
      )

      try session.send(data, toPeers: [peer], with: .reliable)
    } catch {
      print("Fehler beim Senden des DiscoveryTokens: \(error)")
    }
  }

  private func setupNearbyInteraction(with token: NIDiscoveryToken) {
    let config = NINearbyPeerConfiguration(peerToken: token)
    niSession.run(config)
  }
}
