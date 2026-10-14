import CoreLocation
import SwiftUI

struct RouteStepView: View {
  let step: RouteStep
  var typeString: String {
    switch step.type {
    case .pickup: return "PICKUP"
    case .dropoff: return "DROPOFF"
    }
  }

  var typeColor: Color {
    switch step.type {
    case .pickup: return .orange
    case .dropoff: return .blue
    }
  }

  var body: some View {
    HStack(alignment: .top, spacing: 4) {
      Text("\(step.location.name)")
        .font(.headline)
      Text(typeString)
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(typeColor)
        .clipShape(Capsule())

      Text("\(step.order.size)".uppercased(with: .autoupdatingCurrent))
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(typeColor)
        .clipShape(Capsule())
    }
    .padding(5)
    .cornerRadius(12)
  }
}

#Preview {

  let to = Location(
    locationId: UUID().uuidString, name: "Monash Uni", latitude: 1.23, longitude: 4.56)

  let from = Location(
    locationId: UUID().uuidString, name: "Warehouse", latitude: 1.26, longitude: 4.56)

  RouteStepView(
    step:
      RouteStep(
        order:
          Order(
            orderId: UUID().uuidString, runId: UUID().uuidString, size: .large, description: "Desc",
            status: .pending, urgency: .high, from: from, to: to, fromOrganisation: nil,
            toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Doorbell",
            dropoffNotes: "Door", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin),
            createdAt: Date.now),
        type: .dropoff,
        location: to))

}
