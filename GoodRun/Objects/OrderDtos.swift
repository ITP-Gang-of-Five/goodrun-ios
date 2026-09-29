import Foundation


// MARK: - Runs
package struct RunsResponse: Codable {
    let runs: [Run]
}

package struct CreateRunRequest: Codable {
    let orderIds: [String]
}

package struct CreateRunResponse: Codable {
    let runId: String
}

// MARK: - Orders
package struct OrdersListResponse: Codable {
    let orders: [Order]
    let total: Int? // Added for Admin/Org queries
}

package struct CreateOrderRequest: Codable {
    let fromLocationId: String
    let toLocationId: String
    let size: CarSize
    let urgency: Urgency
    let description: String
    let fromOrganisationId: String?
    let toOrganisationId: String?
    let dueAt: Date?
    let pickupNotes: String?
    let dropoffNotes: String?
}

package struct CreateOrderResponse: Codable {
    let orderId: String
}

package struct OrderDetailsResponse: Codable, Identifiable {
    package var id: String { orderId }
    let orderId: String
    let runId: String?
    let size: CarSize
    let status: OrderStatus
    let urgency: Urgency
    let from: Location
    let to: Location
    let fromOrganisation: Organisation?
    let toOrganisation: Organisation?
    let volunteer: UserSummary?
    let createdAt: Date
    let events: [OrderEvent]
    let images: [OrderImage]
    
    package struct OrderEvent: Codable, Identifiable {
        package var id: String { eventId }
        let eventId: String
        let newStatus: OrderStatus
        let createdAt: Date
    }
    
    package struct OrderImage: Codable, Identifiable {
        package var id: String { imageId }
        let imageId: String
        let createdAt: Date
    }
}
