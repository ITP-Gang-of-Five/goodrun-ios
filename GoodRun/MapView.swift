//
//  Map.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import SwiftUI
import WebKit
import MapKit

struct MapPair: Identifiable {
    let id: String
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
    let color: Color
    let isSelected: Bool
}

struct SimpleMapView: View {
    let connections: [MapPair]
    var onDotTapped: (String) -> Void

    var body: some View {
        Map(interactionModes: []) {
            ForEach(connections) { connection in
                
                MapPolyline(coordinates: [connection.startCoordinate, connection.endCoordinate])
                    .stroke(
                        connection.isSelected ? Color.blue : connection.color.opacity(0.6),
                        lineWidth: connection.isSelected ? 4 : 2
                    )
                
                Annotation("Start", coordinate: connection.startCoordinate) {
                    MapDotCircle(color: connection.color, isSelected: connection.isSelected)
                        .onTapGesture {
                            onDotTapped(connection.id)
                        }
                }
                .annotationTitles(.hidden)
                
                Annotation("End", coordinate: connection.endCoordinate) {
                    MapDotCircle(color: connection.color, isSelected: connection.isSelected)
                        .onTapGesture {
                            onDotTapped(connection.id)
                        }
                }
                .annotationTitles(.hidden)
            }
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls { }
        .cornerRadius(12)
        .padding()
    }
}

struct MapDotCircle: View {
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(
                width: isSelected ? 26 : 20,
                height: isSelected ? 26 : 20
            )
            .overlay(
                Circle().stroke(
                    isSelected ? Color.blue : Color.white,
                    lineWidth: isSelected ? 4 : 2
                )
            )
            .shadow(radius: 3)
    }
}
