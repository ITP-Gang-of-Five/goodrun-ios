//
//  File.swift
//  GoodRun
//
//  Created by Max Healey on 14/10/2026.
//

import Foundation

enum LoginStatus {
    case success
    case loading
    case notLoggedIn
    case failure
    case error
}

@Observable
@MainActor
class LoginViewModel {

    let apiService = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
    var loggingIn: LoginStatus = .notLoggedIn

    func login() async {
        loggingIn = .loading
        let result = await apiService.Login(username: "tara@example.com", password: "volunteer")
        if result == nil {
            loggingIn = .error
        } else if result == false {
            loggingIn = .failure
        } else {
            loggingIn = .success
            return
        }
        try? await Task.sleep(for: .seconds(3))
        if loggingIn == .failure || loggingIn == .error {
            loggingIn = .notLoggedIn
        }
    }

}
