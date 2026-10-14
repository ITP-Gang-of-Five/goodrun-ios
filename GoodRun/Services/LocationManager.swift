public import Combine
import CoreLocation
import Foundation

@MainActor
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        self.authorizationStatus = manager.authorizationStatus
        print("AUTH STATUS IS \(self.authorizationStatus, default: "NULL")")
    }
    
    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func fetchCurrentLocation() {
        manager.requestLocation()
    }
    
    func fetchLocationAsync() async throws -> CLLocationCoordinate2D {
        if locationContinuation != nil {
            throw NSError(domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Location request already in progress."])
        }

        let status = manager.authorizationStatus

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // We already have permission. Fetch immediately.
            return try await withCheckedThrowingContinuation { continuation in
                self.locationContinuation = continuation
                manager.requestLocation()
            }
            
        case .notDetermined:
            // We don't have permission yet. Pause and ask.
            return try await withCheckedThrowingContinuation { continuation in
                self.locationContinuation = continuation
                manager.requestWhenInUseAuthorization()
                // We STOP here. The delegate method will take over when the user answers.
            }
            
        case .denied, .restricted:
            // They previously denied it. Throw immediately.
            throw NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied."])
            
        @unknown default:
            throw NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status."])
        }
    }

    // MARK: - CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let latestLocation = locations.last else { return }
            
            // Update UI properties
            Task { @MainActor in self.location = latestLocation.coordinate }
            
            // 3. Resume the continuation and clear it
            locationContinuation?.resume(returning: latestLocation.coordinate)
            locationContinuation = nil
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // 4. Resume throwing the error
            locationContinuation?.resume(throwing: error)
            locationContinuation = nil
        }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            
            // If we have an active continuation waiting for a permission decision...
            if self.locationContinuation != nil {
                switch manager.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    // They tapped "Allow"! Now we can actually fetch the location.
                    manager.requestLocation()
                    
                case .denied, .restricted:
                    // They tapped "Don't Allow". Throw the error back to the caller.
                    self.locationContinuation?.resume(throwing: NSError(domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied."]))
                    self.locationContinuation = nil
                    
                case .notDetermined:
                    // User hasn't answered yet, do nothing.
                    break
                    
                @unknown default:
                    break
                }
            }
        }
    }
}
