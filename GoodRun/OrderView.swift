//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import SwiftUI
import CoreLocation


import SwiftUI

struct ToFromView: View {
    let to: String
    let from: String
    
    @ScaledMetric(relativeTo: .body) private var timelineDotSize: CGFloat = 14
    @ScaledMetric(relativeTo: .body) private var timelineLineWidth: CGFloat = 2
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.white)
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: timelineDotSize, height: timelineDotSize)
                
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: timelineLineWidth)
                    .frame(minHeight: 30)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: timelineDotSize, height: timelineDotSize)
            }
            .padding(.top, 4)
            

            VStack(alignment: .leading, spacing: 20) {
                Text(from)
                Text(to)
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
}



struct OrderView: View {
    let run: Run
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            // Selection Checkbox
            Button(action: {
                withAnimation { isSelected.toggle() }
            }) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .secondary)
                    .font(.title2)
            }
            .padding(.top, 2)
            

            VStack(alignment: .leading, spacing: 12) {
                
                // Title - Run title and Expiration
                HStack {
                    Text(run.toLocation.name)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(run.expiryTime!.formatted())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(urgencyColor) // Replace with your color logic
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                
                // Notes
                if !run.notes.isEmpty {
                    Text(run.notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Route Timeline & Distance Puck
                HStack(alignment: .center) {
                    ToFromView(to: run.toLocation.name, from: run.fromLocation.name)
                    
                    distancePuck.padding(.leading)
                }
            }
        }
        .padding(30)
    }
    
    
    private var distancePuck: some View {
        VStack(spacing: 2) {
            Text(distanceString)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("km")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .frame(width: 56, height: 56) // Perfect circle size
        .background(Color.blue.opacity(0.1)) // Subtle tint background
        .clipShape(Circle())
    }

    
    private var urgencyColor: Color {
        switch run.urgency {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    private var distanceString: String {
        let locationTo = CLLocation(latitude: run.toLocation.latitude, longitude: run.toLocation.longitude)
        let locationFrom = CLLocation(latitude: run.fromLocation.latitude, longitude: run.fromLocation.longitude)

        let distanceInMeters = locationTo.distance(from: locationFrom)
        let distanceInKilometers = distanceInMeters / 1000
        
        return String(format: "%.1f km", distanceInKilometers)
    }
}

#Preview {
    let to = Location(name: "Monash Uni", longitude: 4.56, latitude: 1.23)
    let from = Location(name: "Warehouse", longitude: 4.56, latitude: 1.3)

    RunView(run:
                Run(
                    id: 1,
                    name: "Monash Uni - Warehouse",
                    size: .small,
                    toLocation: to,
                    fromLocation: from,
                    status: .low,
                    createdBy: 1,
                    createdTime: Date(),
                    urgency: .high,
                    assignedTo: [1],
                    expiryTime: Date(),
                    completedTime: Date(),
                    notes: "Handle with care"), isSelected: .constant(true))
}
