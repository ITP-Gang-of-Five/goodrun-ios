import SwiftUI
import CoreLocation

struct ToFromView: View {
    let to: String
    let from: String
    
    @ScaledMetric(relativeTo: .body) private var timelineDotSize: CGFloat = 14
    @ScaledMetric(relativeTo: .body) private var timelineLineWidth: CGFloat = 2
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Timeline
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.white)
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: timelineDotSize, height: timelineDotSize)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: timelineLineWidth)
                    .frame(maxHeight: .infinity)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: timelineDotSize, height: timelineDotSize)
            }
            .padding(.top, 4)
            .padding(.bottom, 6)

            // Addresses
            VStack(alignment: .leading, spacing: 16) {
                Text(from)
                    .font(.subheadline)
                Text(to)
                    .font(.subheadline)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct OrderView: View {
    let order: Order
    @Binding var isSelected: Bool
    
    @ScaledMetric(relativeTo: .title) private var puckSize: CGFloat = 56
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            Toggle(order.orderId, isOn: $isSelected)
                .toggleStyle(CheckboxToggleStyle())
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 12) {
                
                // Title and Urgency
                HStack {
                    Text(order.to.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(order.dueAt!.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(urgencyColor)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                
                if !order.description.isEmpty {
                    Text(order.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Route Timeline & Distance Puck
                HStack(alignment: .center) {
                    ToFromView(to: order.to.name, from: order.from.name)
                    distancePuck
                }
            }
        }
        .padding()
        .cornerRadius(12)
    }
    
    private var distancePuck: some View {
        VStack(spacing: 2) {
            Text(distanceValue)
                .font(.subheadline)
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

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .blue : .secondary)
                .font(.title2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {

    let to = Location(locationId: UUID().uuidString, name: "Monash Uni", latitude: 1.23, longitude: 4.56)

    let from = Location(locationId: UUID().uuidString, name: "Warehouse", latitude: 1.26, longitude: 4.56)



    OrderView(order:

                Order(orderId: UUID().uuidString, runId: UUID().uuidString, size: .large, description: "Desc", status: .pending, urgency: .high, from: from, to: to, fromOrganisation: nil, toOrganisation: nil, volunteer: nil, dueAt: Date.now, pickupNotes: "Doorbell", dropoffNotes: "Door", createdBy: UserSummary(userId: "abcd", name: "Max", role: .admin), createdAt: Date.now),

              isSelected: .constant(true))

}

