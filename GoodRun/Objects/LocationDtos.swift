import Foundation


// MARK: - Tracking
package struct UpdateTrackingLocationRequest: Codable {
    let latitude: Double
    let longitude: Double
}

package struct TrackOrderResponse: Codable {
    let volunteer: UserSummary
    let latitude: Double
    let longitude: Double
    let updatedAt: Date
}

// MARK: - Order Images
package struct UploadImageRequest: Codable {
    let contentType: String
    let data: String
}

package struct UploadImageResponse: Codable {
    let imageId: String
}

// MARK: - Locations & Routing
package struct LocationsResponse: Codable {
    let locations: [Location]
}

package struct AutocompleteResponse: Codable {
    let suggestions: [Suggestion]
    
    package struct Suggestion: Codable, Identifiable {
        package var id: String { suggestionId }
        let suggestionId: String
        let label: String
    }
}

package struct GeocodeResponse: Codable {
    let address: String
    let latitude: Double
    let longitude: Double
}

package struct CreateLocationRequest: Codable {
    let name: String
    let suggestionId: String?
    let address: String?
}

package struct CreateLocationResponse: Codable {
    let locationId: String
}

// MARK: - Routing
package struct CalculateRouteRequest: Codable {
    let stops: [RouteStop]
    
    package struct RouteStop: Codable {
        let locationId: String
        let latitude: Double
        let longitude: Double
    }
}

package struct CalculateRouteResponse: Codable {
    let distanceMeters: Int
    let durationSeconds: Int
    let geometry: RouteGeometry
    let provider: String
    
    package struct RouteGeometry: Codable {
        let type: String
        let coordinates: [[Double]]
    }
}
