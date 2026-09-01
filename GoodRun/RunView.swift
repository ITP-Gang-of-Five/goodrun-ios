//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import SwiftUI
import CoreLocation


struct RunView: View {
    let run: Run
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("\(run.toLocation.name)")
                    .font(.headline)
                
                Text("\(run.expiryTime)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(urgencyColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
            }
            .padding(.horizontal)
            Text("\(run.notes)")
                .padding(.horizontal)

            HStack(alignment: .top, spacing: 16) {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.gray, lineWidth: 1)
                        .frame(width: 14, height: 14)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2, height: 50)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 14, height: 14)
                }
                .padding(.top, 4)
                
                VStack(alignment: .leading, spacing: 26) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("FROM")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text("\(run.toLocation.name)")
                            .font(.headline)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("TO")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Text("\(run.fromLocation.name)")
                            .font(.headline)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text(distanceString)
                Text("X min drive")
                Text("~X min total").fontWeight(.bold)
                Spacer()
            }
            .padding()
        }
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

 /*
#Preview {
    RunView(run: Run(id: 1, name: "Monash to Hospital", size: .large, toLocation: <#T##Location#>, fromLocation: <#T##Location#>, status: <#T##RunStatus#>, createdBy: <#T##String#>, createdTime: <#T##Date#>, urgency: <#T##RunUrgency#>, assignedTo: <#T##[Int]#>, expiryTime: <#T##Date?#>, completedTime: <#T##Date?#>, notes: <#T##String?#>))
}
*/
