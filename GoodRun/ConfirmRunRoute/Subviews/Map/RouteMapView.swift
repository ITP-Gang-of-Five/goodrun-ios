//
//  Map.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import SwiftUI
import WebKit
import MapKit

struct RouteMapView: View {
    let route: [RouteStep]
    @State private var position: MapCameraPosition = .automatic
    
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
    }
}

