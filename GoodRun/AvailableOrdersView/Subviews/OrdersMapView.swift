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
    @Binding var selectedOrderIds: Set<String>
    
    func toggleOrderSelection(orderId: String) {
        if !selectedOrderIds.contains(orderId) {
            selectedOrderIds.insert(orderId)
        }
        else {
            selectedOrderIds.remove(orderId)
        }
    }
    
    var body: some View {
        Map(position: $position, interactionModes: [.pan, .zoom]) {
            
            OrderMapFeatures(orders: orders, selectedOrderIds: $selectedOrderIds) {
                id in toggleOrderSelection(orderId: id)
            }
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
    @Binding var selectedOrderIds: Set<String>
    let onClick: (String) -> Void
    
    var route: [RouteStep] { orders.flatMap { order in
        [RouteStep(order: order, type: .pickup, location: order.to),
         RouteStep(order: order, type: .dropoff, location: order.from)] } }
    
    var body: some MapContent {
        ForEach(orders) { order in
            OrderOnMap(order: order, isSelected: selectedOrderIds.contains(order.id), onClick: onClick)
        }
        LocationDots(route: route)
    }
    
    
}

struct OrderOnMap : MapContent {
    let order: Order
    var isSelected: Bool // Needs to know if its selected but doesnt directly modify
    let onClick: (String) -> Void
    var color: Color { .pseudoRandom(from: order.orderId) }
    var id: String { order.orderId }
    
    var body: some MapContent {
        
        MapPolyline(coordinates: [order.to.ToCoordinate(), order.from.ToCoordinate()])
            .stroke(
                isSelected ? color : color.opacity(0.6),
                lineWidth: isSelected ? 4 : 2
            )
        
        Annotation("Start", coordinate: order.from.ToCoordinate()) {
            MapDotCircle(color: color, isSelected: isSelected)
                .onTapGesture {
                    onClick(order.orderId)
                }
        }
        .annotationTitles(.hidden)
        
        Annotation("End", coordinate: order.to.ToCoordinate()) {
            MapDotCircle(color: color, isSelected: isSelected)
                .onTapGesture {
                    onClick(order.orderId)
                }
        }
        .annotationTitles(.hidden)
    }
}

struct MapDotCircle: View {
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(
                width: isSelected ? 15 : 10,
                height: isSelected ? 15 : 10
            )
            .overlay(
                Circle().stroke(
                    isSelected ? color : Color.white,
                    lineWidth: isSelected ? 2 : 1
                )
            )
            .shadow(radius: 3)
    }
}

