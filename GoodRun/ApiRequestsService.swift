//
//  ApiRequestsService.swift
//  GoodRun
//
//  Created by Max Healey on 15/8/2026.
//

import Foundation

struct HttpRequestReponse {
  let statusCode: Int
  let body: Data?
}

public class ApiRequestsService {

  private let authService: AuthService
  public let url: String

  public init(apiurl: String) {
    authService = AuthService.shared
    url = apiurl
  }

  private func sendRequest(
    endpoint: String, method: String, body: Data? = nil, addToken: Bool = false
  ) async -> HttpRequestReponse? {

    guard let url = URL(string: self.url + endpoint) else { return nil }

    var request = URLRequest(url: url)
    request.httpMethod = method
    request.httpBody = body

    if body != nil {
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    if addToken {
      if let token = self.authService.jwtToken {
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      } else {
        print("No token found, user is not logged in!")
        return nil
      }

    }
    do {
      let (data, response) = try await URLSession.shared.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        return nil
      }
      return HttpRequestReponse(statusCode: httpResponse.statusCode, body: data)

    } catch {
      print("Request failed: \(error.localizedDescription)")
      return nil
    }
  }

  public func login(username: String, password: String) async throws -> Bool? {

    let credentials = LoginRequest(username: username, password: password)
    let bodydata = try? JSONEncoder().encode(credentials)

    let response: HttpRequestReponse? = await sendRequest(
      endpoint: "/api/v0/auth/login",
      method: "POST",
      body: bodydata,
      addToken: false)

    if response == nil || response?.body == nil {
      return nil
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let loginResponse: LoginResponse = try decoder.decode(
      LoginResponse.self, from: (response?.body)!)

    if loginResponse.jwtToken.isEmpty {
      return false
    }

    authService.jwtToken = loginResponse.jwtToken

    return true
  }

  public func signup(username: String, password: String) async throws -> Bool? {

    let credentials = LoginRequest(username: username, password: password)
    let bodydata = try? JSONEncoder().encode(credentials)

    let response: HttpRequestReponse? = await sendRequest(
      endpoint: "/api/v0/auth/signup",
      method: "POST",
      body: bodydata,
      addToken: false)

    if response == nil || response?.body == nil {
      return nil
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let loginResponse: LoginResponse = try decoder.decode(
      LoginResponse.self, from: (response?.body)!)

    if loginResponse.jwtToken.isEmpty {
      return false
    }

    authService.jwtToken = loginResponse.jwtToken

    return true
  }

  public func getAllRuns() async throws -> [RunResponseDto] {
    let response: HttpRequestReponse? = await sendRequest(
      endpoint: "/api/v0/runs",
      method: "POST",
      body: nil,
      addToken: true)

    if response == nil || response?.body == nil {
      return []
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let runs: [RunResponseDto] = try decoder.decode([RunResponseDto].self, from: (response?.body)!)

    return runs

  }

  public func acceptRun(runId: Int) async throws -> Bool {

    var body = RunIdDto(runId: runId)
    let bodydata = try? JSONEncoder().encode(body)

    let response: HttpRequestReponse? = await sendRequest(
      endpoint: "/api/v0/auth/accept",
      method: "POST",
      body: nil,
      addToken: true)

    if response == nil {
      return false
    }
    return response!.statusCode == 200

  }

}
