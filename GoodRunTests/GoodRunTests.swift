//
//  GoodRunTests.swift
//  GoodRunTests
//
//  Created by Max Healey on 20/8/2026.
//

import Testing

struct GoodRunTests {

    @Test func example() async throws {
        let service = ApiRequestsService(apiurl: "http://127.0.0.1:8000")
        //_ = try? await service.Signup(username: "maxahealey@icloud.com", password: "Password@123")
        _ = try? await service.Login(username: "tara@example.com", password: "volunteer")
        _ = try? await service.GetAvailableOrders()
    }

}
