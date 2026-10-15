//
//  HomeView.swift
//  GoodRun
//
//  Created by Max Healey on 14/10/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var path: [AppScreen] = []
    let model = HomeViewModel()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Home")

                // NavigationLink automatically appends to the $path array
                NavigationLink(value: AppScreen.orders) {
                    Text("Start Run")
                }
            }
            .navigationDestination(for: AppScreen.self) { page in
                switch page {
                case .orders:
                    // 3. Pass the path binding to child views
                    AvailableOrdersView(path: $path)

                case .run(let runOrders):
                    RunView(runOrders: runOrders, path: $path)

                }
            }.task {
                await model.getCurrentRun()
            }
        }
    }
}

#Preview {
    HomeView()
}
