import CoreLocation
//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import SwiftUI

import CoreLocation
//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import SwiftUI

struct RunView: View {
    
    let apiService = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
    let routeService = RouteService()
    
    var runOrders: [Order]
    @State var steps: [RouteStep] = []
    @State private var showingAutoFixNotice = false

    
    var body: some View {
        ZStack {
            VStack {
                Text("Your Run:")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                RouteMapView(route: steps)
                    .containerRelativeFrame(.vertical, alignment: .top) { length, _ in
                        length * 0.5
                    }
                
                List {
                    ForEach(steps, id: \.id) { item in
                        RouteStepView(step: item)
                    }
                    .onMove { source, destination in
                        var tempSteps = steps
                        tempSteps.move(fromOffsets: source, toOffset: destination)
                        if routeService.validateRoute(route: tempSteps) {
                            withAnimation(.default) {
                                self.steps = tempSteps
                            }
                        }
                        else {
                            withAnimation(.spring(duration: 0.3)) {
                                showingAutoFixNotice = true
                            }
                            Task {
                                try? await Task.sleep(nanoseconds: 1_500_000_000)
                                withAnimation(.default) {
                                    showingAutoFixNotice = false
                                }
                            }
                            DispatchQueue.main.async {
                                let currentSteps = self.steps
                                self.steps = []
                                self.steps = currentSteps
                            }
                        }
                    }
                }
                .environment(\.editMode, .constant(.active))
            }
            .onAppear {
                if steps.isEmpty {
                    steps = routeService.naiveRoute(orders: runOrders)
                }
            }
        }
        if showingAutoFixNotice {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left.and.right.circle.fill")
                    .foregroundColor(.red)
                Text("Cannot dropoff before pickup")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 5)
            .transition(.move(edge: .top).combined(with: .opacity))
            .padding(.top, 10)
            .frame(maxHeight: .infinity, alignment: .leading)
        }
    }
    
}


#Preview {
    let to = Location(locationId: UUID().uuidString, name: "Monash Uni1", latitude: 2, longitude: 4.56)
    let from = Location(locationId: UUID().uuidString, name: "Warehouse1", latitude: 1.26, longitude: 4.56)
    let to2 = Location(locationId: UUID().uuidString, name: "Monash Uni2", latitude: 4, longitude: 4.0)
    let from2 = Location(locationId: UUID().uuidString, name: "Warehouse2", latitude: -1.26, longitude: 8)
    
    let orders = [
        Order(orderId: UUID().uuidString, runId: UUID().uuidString, size: .large, description: "Order 1", status: .pending, urgency: .high, from: from, to: to, fromOrganisation: nil, toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Doorbell", dropoffNotes: "Door", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin), createdAt: Date.now),
        Order(orderId: UUID().uuidString, runId: UUID().uuidString, size: .small, description: "Order 2", status: .pending, urgency: .low, from: from2, to: to2, fromOrganisation: nil, toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Back door", dropoffNotes: "Porch", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin), createdAt: Date.now)
    ]
    
    NavigationStack {
        RunView(runOrders: orders)
    }.ignoresSafeArea()
}
