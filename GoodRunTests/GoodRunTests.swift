//
//  GoodRunTests.swift
//  GoodRunTests
//
//  Created by Max Healey on 20/8/2026.
//

import Foundation
import Testing

struct GoodRunTests {

  @Test func example() async throws {
    let service = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
    //_ = try? await service.Signup(username: "maxahealey@icloud.com", password: "Password@123")
    _ = try? await service.Login(username: "tara@example.com", password: "volunteer")
    _ = try? await service.GetAvailableOrders()
  }

  @Test func route() {
    let to = Location(
      locationId: UUID().uuidString, name: "Monash Uni", latitude: 1.23, longitude: 4.56)

    let from = Location(
      locationId: UUID().uuidString, name: "Warehouse", latitude: 1.26, longitude: 4.56)

    let orders = [
      Order(
        orderId: UUID().uuidString, runId: UUID().uuidString, size: .large, description: "Desc",
        status: .pending, urgency: .high, from: from, to: to, fromOrganisation: nil,
        toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Doorbell",
        dropoffNotes: "Door", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin),
        createdAt: Date.now)
    ]

    let service = RouteService()

    let route = service.naiveRoute(orders: orders)
    print(route)
  }

}
