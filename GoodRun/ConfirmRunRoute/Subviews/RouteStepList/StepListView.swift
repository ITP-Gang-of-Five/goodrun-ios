import Foundation
//
//  StepList.swift
//  GoodRun
//
//  Created by Max Healey on 12/10/2026.
//
import SwiftUI

struct StepListView: View {

    @Binding var steps: [RouteStep]
    @Binding var showingErrorMessage: Bool
    let routeService = RouteService()

    var body: some View {
        List {
            ForEach(steps, id: \.id) { item in
                RouteStepView(step: item)
            }
            .onMove { source, destination in
                var tempSteps = steps
                tempSteps.move(fromOffsets: source, toOffset: destination)
                if routeService.validateRoute(route: tempSteps) {
                    withAnimation(.default) {
                        self.steps = tempSteps
                    }
                } else {
                    withAnimation(.spring(duration: 0.3)) {
                        showingErrorMessage = true
                    }
                    Task {
                        try? await Task.sleep(nanoseconds: 1_500_000_000)
                        withAnimation(.default) {
                            showingErrorMessage = false
                        }
                    }
                    DispatchQueue.main.async {
                        let currentSteps = self.steps
                        self.steps = []
                        self.steps = currentSteps
                    }
                }
            }
        }
        .environment(\.editMode, .constant(.active))
    }
}
