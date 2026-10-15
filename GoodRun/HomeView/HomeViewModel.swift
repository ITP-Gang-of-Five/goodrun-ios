//
//  HomeView.swift
//  GoodRun
//
//  Created by Max Healey on 14/10/2026.
//

import Foundation

class HomeViewModel {
    let hasCurrentRun: Bool = false
    let currentRun: Run? = nil

    let loading: Bool = false

    let apiService = ApiRequestsService(apiurl: "http://127.0.0.1:8000")

    func getCurrentRun() async {
        _ = try? await apiService.GetRuns()
    }
}
