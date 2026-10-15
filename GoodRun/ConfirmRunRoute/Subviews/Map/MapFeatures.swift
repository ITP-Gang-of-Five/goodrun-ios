//
//  LocationDotView.swift
//  GoodRun
//
//  Created by Max Healey on 12/10/2026.
//

import Foundation
import MapKit
import SwiftUI

struct Lines: MapContent {
    let route: [RouteStep]

    var body: some MapContent {
        ForEach(Array(zip(route.indices, route.indices.dropFirst())), id: \.0) { i, j in
            MapPolyline(coordinates: [route[i].location.toCoordinate(), route[j].location.toCoordinate()])
                .stroke(
                    Color.pseudoRandom(from: "\(i)"),
                    lineWidth: 8
                )
        }
    }
}

struct LocationDots: MapContent {
    let route: [RouteStep]

    var body: some MapContent {
        ForEach(route.indices, id: \.self) { i in
            Annotation(coordinate: route[i].location.toCoordinate()) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Text(route[i].type == .pickup ? "📦" : "📮")
                            .font(.system(size: 11))
                    )
                    .shadow(radius: 3)

            } label: {
                Text("\(route[i].location.name)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
            }.annotationTitles(.visible)

        }
    }
}

struct RecentreButton: View {

    @Binding var position: MapCameraPosition

    var body: some View {
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
}
