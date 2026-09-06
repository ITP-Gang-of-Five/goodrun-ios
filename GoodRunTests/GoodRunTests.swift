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
    var res = try? await service.signup(username: "maxauhealey@gmail.com", password: "Password@123")
    res = try? await service.login(username: "maxauhealey@gmail.com", password: "Password@123")
    let runs = try? await service.getAllRuns()
    if res == nil {
      return
    }
    print(res!)
  }

}
