//
//  Enums.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import Foundation

package struct ErrorResponse: Codable, Error {
    let error: ErrorDetail
    
    package struct ErrorDetail: Codable {
        let code: ApiErrorCode
        let description: String
    }
}

package struct Location: Codable, Identifiable {
    package var id: String { locationId }
    let locationId: String
    let name: String
    let latitude: Double
    let longitude: Double
}

package struct Organisation: Codable, Identifiable {
    package var id: String { userId }
    let userId: String
    let name: String
}

package struct UserSummary: Codable, Identifiable {
    package var id: String { userId }
    let userId: String
    let name: String
    let role: Role?
}

package struct Order: Codable, Identifiable {
    package var id: String { orderId }
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

package struct Run: Codable, Identifiable {
    package var id: String { runId }
    let runId: String
    let status: RunStatus
    let volunteer: UserSummary?
    let createdAt: Date
    let startedAt: Date?
    let completedAt: Date?
    let orders: [Order]
}
