//
//  Enums.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let error: ErrorDetail
    
    struct ErrorDetail: Codable {
        let code: ApiErrorCode
        let description: String
    }
}

struct Location: Codable, Identifiable {
    var id: String { locationId }
    let locationId: String
    let name: String
    let latitude: Double
    let longitude: Double
}

struct Organisation: Codable, Identifiable {
    var id: String { userId }
    let userId: String
    let name: String
}

struct UserSummary: Codable, Identifiable {
    var id: String { userId }
    let userId: String
    let name: String
    let role: Role? // Sometimes provided (e.g. login), sometimes omitted
}

struct Order: Codable, Identifiable {
    var id: String { orderId }
    let orderId: String
    let runId: String?
    let size: CarSize
    let description: String
    let status: OrderStatus
    let urgency: Urgency
    let from: Location
    let to: Location
    let fromOrganisation: Organisation?
    let toOrganisation: Organisation?
    let volunteer: UserSummary?
    let dueAt: Date?
    let pickupNotes: String?
    let dropoffNotes: String?
    let createdBy: UserSummary
    let createdAt: Date
}

struct Run: Codable, Identifiable {
    var id: String { runId }
    let runId: String
    let status: RunStatus
    let volunteer: UserSummary?
    let createdAt: Date
    let startedAt: Date?
    let completedAt: Date?
    let orders: [Order]
}
