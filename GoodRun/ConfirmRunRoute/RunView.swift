//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import CoreLocation
import SwiftUI

struct RunView: View {

  @State var viewModel: RunRouteViewModel
  let routeService = RouteService()
  var runOrders: [Order]

  init(runOrders: [Order]) {
    self.viewModel = RunRouteViewModel(runOrders: runOrders, routeService: self.routeService)
    self.runOrders = []
  }

  var body: some View {
      Group {
          if viewModel.loadingSteps {
              ProgressView("Loading data...")
          }
          else {
              ZStack {
                  VStack {
                      Text("Your Run:")
                          .font(.title2)
                          .bold()
                          .frame(maxWidth: .infinity, alignment: .leading)
                          .padding(.horizontal)
                      
                      RouteMapView(route: viewModel.steps)
                          .ignoresSafeArea(edges: .vertical)
                      
                      
                      StepListView(steps: $viewModel.steps, showingErrorMessage: $viewModel.showingError)
                      
                  }
                  if viewModel.showingError { InvalidRouteError() }
                  
              }
          }
      }.task {
          viewModel.loadingSteps = true
          await viewModel.loadSteps()
      }
  }
}

#Preview {
    
  let to = Location(
    locationId: UUID().uuidString, name: "Monash Uni1", latitude: 2, longitude: 4.56)
  let from = Location(
    locationId: UUID().uuidString, name: "Warehouse1", latitude: 1.26, longitude: 4.56)
  let to2 = Location(
    locationId: UUID().uuidString, name: "Monash Uni2", latitude: 4, longitude: 4.0)
  let from2 = Location(
    locationId: UUID().uuidString, name: "Warehouse2", latitude: -1.26, longitude: 8)

  let orders = [
    Order(
      orderId: UUID().uuidString, runId: UUID().uuidString, size: .small, description: "Order 1",
      status: .pending, urgency: .low, from: from, to: to, fromOrganisation: nil,
      toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Back door",
      dropoffNotes: "Porch", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin), createdAt: Date.now),
      
    Order(
      orderId: UUID().uuidString, runId: UUID().uuidString, size: .small, description: "Order 2",
      status: .pending, urgency: .low, from: from2, to: to2, fromOrganisation: nil,
      toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Back door",
      dropoffNotes: "Porch", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin),
      createdAt: Date.now),
  ]

  RunView(runOrders: orders)
}
