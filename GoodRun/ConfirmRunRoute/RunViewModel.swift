//
//  SwiftUIView.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//
import CoreLocation
import SwiftUI

@Observable

class RunRouteViewModel {
    var steps: [RouteStep]
    let runOrders: [Order]
    var showingError = false
    private let routeService: RouteService
    var loadingSteps = true

    init(runOrders: [Order], routeService: RouteService) {
        self.routeService = routeService
        self.runOrders = runOrders
        self.steps = []
    }

    func loadSteps() async {
        print("1")
        self.steps = await routeService.naiveRoute(orders: runOrders)
        print("2")
        loadingSteps = false
    }

    func moveRouteStep(from source: IndexSet, to destination: Int) {
        var tempSteps = steps
        tempSteps.move(fromOffsets: source, toOffset: destination)

        if routeService.validateRoute(route: tempSteps) {
            self.steps = tempSteps
            return
        }

        withAnimation(.spring(duration: 0.3)) {
            showingError = true
        }

        Task {
            @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            withAnimation(.default) {
                showingError = false
            }
        }

        let currentSteps = self.steps
        self.steps = []
        self.steps = currentSteps

    }
}
