<<<<<<< HEAD
<<<<<<< Updated upstream
import CoreLocation
//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import SwiftUI
=======
//
//  ContentView.swift
//  GoodRun
//
//  Created by Max Healey on 14/8/2026.
//

import SwiftUI

struct RunView: View {
    
    let apiService = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
    let routeService = RouteService()
    
    @State var runOrders: [Order] = []
    @State private var draggedOrder: Order?
    
    var body: some View {
        
        Text("Your run")
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
        let mapConnections = runOrders.map { order in
            MapPair(
                id: order.id,
                startCoordinate: CLLocationCoordinate2D(latitude: order.to.latitude, longitude: order.to.longitude),
                endCoordinate: CLLocationCoordinate2D(latitude: order.from.latitude, longitude: order.from.longitude),
                color: Color.pseudoRandom(from: order.id),
                isSelected: false
            )
        }
        
        SimpleMapView(connections: mapConnections) {_ in 
        }
        .containerRelativeFrame(.vertical, alignment: .top) { length, _ in
            length * 0.5
        }
        
        List {
                    ForEach(runOrders, id: \.self) { item in
                        CompressedOrderView(order: item)
                    }
                    .onMove { source, destination in
                        runOrders.move(fromOffsets: source, toOffset: destination)
                    }
                }
                .environment(\.editMode, .constant(.active))
        .task {
            do {
                try await apiService.Login(username: "tara@example.com", password: "volunteer")
                runOrders = try await Array(apiService.GetAvailableOrders().orders.prefix(3))
            } catch {
                print("Error fetching orders")
                runOrders = []
            }
        }
        
        
    }
    
        
    private func moveItem(from source: Order, to destination: Order) {
        guard let fromIndex = runOrders.firstIndex(of: source),
              let toIndex = runOrders.firstIndex(of: destination) else { return }
        
        if fromIndex != toIndex {
            withAnimation(.default) {
                runOrders.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }
    
}


    

#Preview {
    NavigationStack {
        RunView()
    }
}

>>>>>>> Stashed changes
=======
>>>>>>> origin/master

