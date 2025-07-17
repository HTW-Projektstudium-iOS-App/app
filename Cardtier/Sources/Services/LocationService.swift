import CoreLocation
import Foundation

class LocationService: NSObject, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  private var completion: ((CLLocationCoordinate2D) -> Void)?
  private var hasCompleted = false

  static let appleParkLocation = CLLocationCoordinate2D(
    latitude: 37.3349,
    longitude: -122.0090
  )

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func getCurrentLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
    self.completion = completion
    self.hasCompleted = false

    let authStatus = locationManager.authorizationStatus

    switch authStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()

    case .authorizedWhenInUse, .authorizedAlways:
      locationManager.requestLocation()

    case .denied, .restricted:
      completion(Self.appleParkLocation)

    @unknown default:
      completion(Self.appleParkLocation)
    }
  }

  // MARK: - CLLocationManagerDelegate

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard !hasCompleted, let location = locations.first, let completion = completion else { return }
    hasCompleted = true
    completion(location.coordinate)
    self.completion = nil
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    guard !hasCompleted, let completion = completion else { return }
    hasCompleted = true
    completion(Self.appleParkLocation)
    self.completion = nil
  }

  func locationManager(
    _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
  ) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      if !hasCompleted {
        locationManager.requestLocation()
      }

    case .denied, .restricted:
      guard !hasCompleted, let completion = completion else { return }
      hasCompleted = true
      completion(Self.appleParkLocation)
      self.completion = nil

    case .notDetermined:
      break

    @unknown default:
      guard !hasCompleted, let completion = completion else { return }
      hasCompleted = true
      completion(Self.appleParkLocation)
      self.completion = nil
    }
  }
}
