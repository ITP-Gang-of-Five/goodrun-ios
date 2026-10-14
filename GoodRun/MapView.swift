//
//  MapView.swift
//  GoodRun
//
//  Created by Max Healey on 14/10/2026.
//
import SwiftUI

struct MapView: View {
    @StateObject private var locationManager = LocationManager.shared

    var body: some View {
        Group {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                Button("Share Location") {
                    locationManager.requestLocationPermission()
                }
                
            case .authorizedWhenInUse, .authorizedAlways:
                if let location = locationManager.location {
                    Text("Your location is: \(location.latitude), \(location.longitude)")
                } else {
                    Text("Fetching location...")
                        .onAppear {
                            locationManager.fetchCurrentLocation()
                        }
                }
                
            case .denied, .restricted:
                Text("We need your location for this to work. Please enable it in Settings.")
                
            default:
                ProgressView()
            }
        }
    }
}

#Preview {
    MapView()
}
