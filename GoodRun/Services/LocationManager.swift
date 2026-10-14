//
//  LocationManager.swift
//  GoodRun
//
//  Created by Max Healey on 3/10/2026.
//

public import Combine
import CoreLocation
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

  private let manager = CLLocationManager()

  @Published var location: CLLocationCoordinate2D?
  @Published var authorizationStatus: CLAuthorizationStatus?

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func requestLocationPermission() {
    manager.requestWhenInUseAuthorization()
  }

  func fetchCurrentLocation() {
    manager.requestLocation()
  }

  // MARK: - CLLocationManagerDelegate Methods

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else { return }

    self.location = firstLocation.coordinate
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to find user's location: \(error.localizedDescription)")
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    self.authorizationStatus = manager.authorizationStatus
  }
}
