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

    let apiService = ApiRequestsService(apiurl: "")

    func getCurrentRun() {

    }
}
