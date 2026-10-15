//
//  Map.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import MapKit
import SwiftUI
import WebKit

struct RouteMapView: View {
    let route: [RouteStep]
    @State private var position: MapCameraPosition = .automatic
    let locationManager = LocationManager.shared

    var body: some View {
        Map(position: $position, interactionModes: [.pan, .zoom]) {

            Lines(route: route)
            LocationDots(route: route)
            UserAnnotation()

        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls { MapUserLocationButton() }
        .overlay(alignment: .bottomTrailing) {
            RecentreButton(position: $position)
        }
        .cornerRadius(12)
        .padding()
        .onAppear {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestLocationPermission()
            }
        }
    }
}
