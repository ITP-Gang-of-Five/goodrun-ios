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
            
            ForEach(Array(zip(route.indices, route.indices.dropFirst())), id: \.0) { i, j in
                
                MapPolyline(coordinates: [route[i].location.ToCoordinate(), route[j].location.ToCoordinate()])
                    .stroke(
                        Color.pseudoRandom(from: "\(i)"),
                        lineWidth: 8
                    )
            }
            ForEach(route.indices, id: \.self) { i in
                Annotation(coordinate: route[i].location.ToCoordinate()) {
                    Circle()
                        .fill(Color.white)
                        .frame(
                            width: 20,
                            height: 20,
                        )
                        .overlay(
                            Text(route[i].type == .pickup ? "📦" : "📮")
                                .font(.system(size: 11))
                        )
                        .shadow(radius: 3)
                
                } label: {
                    Text("\(i)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                .annotationTitles(.visible)
                
            }
            UserAnnotation()
            
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls { MapUserLocationButton() }
        .overlay(alignment: .bottomTrailing) {
                Button {
                    withAnimation(.easeInOut) {
                        position = .automatic
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .blue)
                        .padding()
                        .shadow(radius: 4)
                }
                .padding(.trailing, 10)
                .padding(.bottom, 10)
            }
            .cornerRadius(12)
            .padding()
    }
}

