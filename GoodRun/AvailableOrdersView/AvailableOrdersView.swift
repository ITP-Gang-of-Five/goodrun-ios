//
//  ContentView.swift
//  GoodRun
//
//  Created by Max Healey on 14/8/2026.
//

import SwiftUI

struct AvailableOrdersView: View {

    let apiService = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
    @State var allOrders: [Order] = []
    @Binding var path: [AppScreen]

    var filteredOrders: [Order] {
        switch selectedFilterOption {
        case .all:
            return allOrders
        case .urgent:
            return allOrders.filter { $0.urgency == .high }
        }
    }

    @State var selectedFilterOption: FilterSetting = .all
    @State var selectedOrderIDs: Set<String> = []

    var selectedOrders: [Order] {
        allOrders.filter { selectedOrderIDs.contains($0.id) }
    }

    var body: some View {

        Text("Orders for you")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.title)
            .padding(.horizontal)

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

        OrdersMapView(orders: selectedOrders, selectedOrderIds: $selectedOrderIDs)
            .containerRelativeFrame(.vertical, alignment: .top) { length, _ in
                length * 0.35
            }

        VStack {
            List(filteredOrders) { order in

                let isSelectedBinding = Binding<Bool>(
                    get: { selectedOrderIDs.contains(order.id) },
                    set: { isAdding in
                        if isAdding {
                            selectedOrderIDs.insert(order.id)
                        } else {
                            selectedOrderIDs.remove(order.id)
                        }
                    }
                )

                OrderView(order: order, isSelected: isSelectedBinding)

            }

        }

        .task {
            do {
                allOrders = try await apiService.getAvailableOrders().orders
                selectedFilterOption = .all
            } catch {
                print("Error fetching orders")
                allOrders = []
            }
        }
        if !selectedOrderIDs.isEmpty {
            BuildRunPopupView(selectedOrders: selectedOrders, selectedOrderIDs: $selectedOrderIDs, path: _path)
        }
    }

}

#Preview {
    NavigationStack {
        AvailableOrdersView(path: .constant([]))
    }
}

enum FilterSetting: String, CaseIterable, Identifiable {
    case all = "All"
    case urgent = "Urgent"

    var id: Self { self }
}

extension Color {
    public static func pseudoRandom(from seed: String) -> Color {
        let hash = abs(seed.hashValue)
        let hue = Double(hash % 1000) / 1000.0
        return Color(hue: hue, saturation: 0.8, brightness: 0.9)
    }
}
