//
//  Map.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import SwiftUI
import WebKit
import MapKit

struct OrdersMapView: View {
    let orders: [Order]
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position, interactionModes: [.pan, .zoom]) {
            
            OrderMapFeatures(orders: orders)
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

struct OrderMapFeatures: MapContent {
    let orders: [Order]
    let route: [RouteStep]
    
    init(orders: [Order]) {
        self.route = orders.flatMap { order in
            [RouteStep(order: order, type: .pickup, location: order.to),
             RouteStep(order: order, type: .dropoff, location: order.from)] }
        self.orders = orders
    }
    

    var body: some MapContent {
        ForEach(orders) { order in
            MapPolyline(coordinates: [order.to.ToCoordinate(), order.from.ToCoordinate()])
                .stroke(
                    Color.pseudoRandom(from: "\(order.id)"),
                    lineWidth: 8
                )
        }
        LocationDots(route: route)
    }
}


