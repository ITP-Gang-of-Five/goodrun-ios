//
//  ContentView.swift
//  GoodRun
//
//  Created by Max Healey on 14/8/2026.
//

import SwiftUI

enum FilterSetting: String, CaseIterable, Identifiable {
    case all = "All"
    case urgent = "Urgent"
    
    var id: Self { self }
}

extension Color {
    static func pseudoRandom(from seed: String) -> Color {
        let hash = abs(seed.hashValue)
        let hue = Double(hash % 1000) / 1000.0
        return Color(hue: hue, saturation: 0.8, brightness: 0.9)
    }
}

struct HomeView: View {
    
    let apiService = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
    @State var allOrders: [Order] = []
    
    var filteredOrders: [Order] {
        switch selectedFilterOption {
        case .all:
            return allOrders
        case .urgent:
            return allOrders.filter {$0.urgency == .high}
        }
    }
    
    @State var selectedFilterOption: FilterSetting = .all
    @State var selectedOrderIDs: Set<String> = []
    
    var body: some View {
            
        Text("Orders for you")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.title)
            .padding()
        
        Text("\(allOrders.count) runs near you")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        HStack {
            Button("All") {
                selectedFilterOption = .all
            }
            .buttonStyle(.glassProminent)
            .tint(.blue)
            Button("Urgent") {
                selectedFilterOption = .urgent
            }
            .buttonStyle(.glassProminent)
            .tint(.purple)
        }
        
        let mapConnections = allOrders.map { order in
            MapPair(
                id: order.id,
                startCoordinate: CLLocationCoordinate2D(latitude: order.to.latitude, longitude: order.to.longitude),
                endCoordinate: CLLocationCoordinate2D(latitude: order.from.latitude, longitude: order.from.longitude),
                color: Color.pseudoRandom(from: order.id),
                isSelected: selectedOrderIDs.contains(order.id)
            )
        }
        
        SimpleMapView(connections: mapConnections) {
            tappedID in
            if selectedOrderIDs.contains(tappedID) {
                selectedOrderIDs.remove(tappedID)
            } else {
                selectedOrderIDs.insert(tappedID)
            }
        }
        .containerRelativeFrame(.vertical, alignment: .top) { length, _ in
            length * 0.25
        }
        
        VStack {
            List(filteredOrders) { order in
                
                let isSelectedBinding = Binding<Bool>(
                    get: { selectedOrderIDs.contains(order.id) },
                    set: { isAdding in
                        if isAdding {
                            selectedOrderIDs.insert(order.id)
                        } else {
                            selectedOrderIDs.remove(order.id) }
                    }
                )
                
                OrderView(order: order, isSelected: isSelectedBinding)
                    
            }
            
        }
        
        .task {
            do {
                try await apiService.Login(username: "tara@example.com", password: "volunteer")
                allOrders = try await apiService.GetAvailableOrders().orders
                allOrders += allOrders
                selectedFilterOption = .all
            } catch {
                print("Error fetching orders")
                allOrders = []
            }
        }
        if !selectedOrderIDs.isEmpty {
            
            HStack {
                Text("\(selectedOrderIDs.count) selected")
                    .font(.headline)
                    .padding()
                
                NavigationLink(destination: LoginView(currentScreen: .constant(.login))) {
                    Text("Build run")
                        .frame(maxWidth: .infinity)
                        .backgroundStyle(.red)
                        .padding()
                        
                    }
                .buttonStyle(.automatic)
                
                
            }
            
        }
    }
    
}


    

#Preview {
    NavigationStack {
        HomeView()
    }
}
