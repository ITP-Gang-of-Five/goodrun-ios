import Foundation


// MARK: - Profiles & Volunteers
struct ProfileResponse: Codable, Identifiable {
    var id: String { userId }
    let userId: String
    let name: String
    let email: String
    let role: Role
    let carSize: CarSize?
    let createdAt: Date
}

struct UpdateProfileRequest: Codable {
    let name: String?
    let carSize: CarSize?
}

struct VolunteersResponse: Codable {
    let volunteers: [VolunteerProfile]
    
    struct VolunteerProfile: Codable, Identifiable {
        var id: String { userId }
        let userId: String
        let name: String
        let email: String
        let carSize: CarSize?
        let createdAt: Date
    }
}

struct VolunteerStatsResponse: Codable, Identifiable {
    var id: String { userId }
    let userId: String
    let name: String
    let email: String
    let carSize: CarSize?
    let createdAt: Date
    let stats: VolunteerStats
    
    struct VolunteerStats: Codable {
        let runsCompleted: Int
        let runsCancelled: Int
        let ordersDelivered: Int
        let lastRunAt: Date?
    }
}

struct CreateVolunteerRequest: Codable {
    let name: String
    let email: String
    let password: String
    let carSize: CarSize
}

struct CreateVolunteerResponse: Codable {
    let userId: String
}

// MARK: - Organisations
struct OrganisationsResponse: Codable {
    let organisations: [Organisation]
}

struct CreateOrganisationRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct CreateOrganisationResponse: Codable {
    let userId: String
}
