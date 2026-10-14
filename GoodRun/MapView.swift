//
//  Map.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import SwiftUI
import WebKit
import MapKit



struct SimpleMapView: View {
    let connections: [MapPair]
    
    var onDotTapped: (String) -> Void

    var body: some View {
        Map(interactionModes: []) {
            
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls { }
        .cornerRadius(12)
        .padding()
    }
}


