import SwiftUI
import CoreLocation


struct RouteStepView: View {
    let step: RouteStep
    
    @ScaledMetric(relativeTo: .title) private var puckSize: CGFloat = 40
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            
            VStack(alignment: .leading, spacing: 2) {
                
                // Title and Urgency
                HStack {
                    Text(location.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    
                }
                
                if !order.description.isEmpty {
                    Text(order.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Route Timeline & Distance Puck
                HStack(alignment: .center) {
                    Text("\(order.to.name) to \(order.from.name)")
                        .font(.caption)
                    
                }
            }
        }
        .padding(5)
        .cornerRadius(12)
    }
    
    private var distancePuck: some View {
        VStack(spacing: 2) {
            Text(distanceValue)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("km")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .frame(width: puckSize, height: puckSize)
        .background(Color.blue.opacity(0.1))
        .clipShape(Circle())
    }
    
    private var urgencyColor: Color {
        switch order.urgency {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private var distanceValue: String {
        let locationTo = CLLocation(latitude: order.to.latitude, longitude: order.to.longitude)
        let locationFrom = CLLocation(latitude: order.from.latitude, longitude: order.from.longitude)

        let distanceInKilometers = locationTo.distance(from: locationFrom) / 1000
        return String(format: "%.1f", distanceInKilometers)
    }
}

#Preview {

    let to = Location(locationId: UUID().uuidString, name: "Monash Uni", latitude: 1.23, longitude: 4.56)

    let from = Location(locationId: UUID().uuidString, name: "Warehouse", latitude: 1.26, longitude: 4.56)



    CompressedOrderView(order:

                Order(orderId: UUID().uuidString, runId: UUID().uuidString, size: .large, description: "Desc", status: .pending, urgency: .high, from: from, to: to, fromOrganisation: nil, toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Doorbell", dropoffNotes: "Door", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin), createdAt: Date.now))

}

