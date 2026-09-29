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
    
    private func sendRequest(endpoint: String, method: String, body: Data? = nil, addToken: Bool = false) async -> HttpRequestReponse? {
        
        guard let url = URL(string: self.url + endpoint) else { return nil }
            
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        if body != nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if (addToken) {
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
    
    public func Login(username: String, password: String) async throws -> Bool? {
        
        let credentials = LoginRequest(email: username, password: password)
        let bodydata = try? JSONEncoder().encode(credentials)
        
        let response: HttpRequestReponse? = await sendRequest(
            endpoint: "/api/v0/auth/login",
            method: "POST",
            body: bodydata,
            addToken: false
        )
        
        guard let response = response, let responseBody = response.body else {
            return nil
        }
        
        let decoder = JSONDecoder()
        // decoder.dateDecodingStrategy = .iso8601 // Uncomment if your ErrorResponse has dates
        
        do {
            // 1. Attempt to decode the successful login response
            let loginResponse = try decoder.decode(LoginResponse.self, from: responseBody)
            
            if loginResponse.accessToken.isEmpty {
                return false
            }
            
            authService.jwtToken = loginResponse.accessToken
            return true
            
        } catch let successDecodeError {
            // 2. If it fails (likely due to an invalid login returning an error body)
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: responseBody)
                print("Login API Error: \(errorResponse.error.code.rawValue) - \(errorResponse.error.description)")
                return false
                
            } catch let errorDecodeError {
                // 3. If it isn't a known ErrorResponse either, print everything to debug
                print("Failed to decode success response: \(successDecodeError)")
                print("Failed to decode error response: \(errorDecodeError)")
                
                if let rawString = String(data: responseBody, encoding: .utf8) {
                    print("Raw response body: \(rawString)")
                }
                
                return false
            }
        }
    }
    
    
    package func GetAvailableOrders() async throws -> OrdersListResponse {
        let response: HttpRequestReponse? = await sendRequest(
            endpoint: "/api/v0/orders/available",
            method: "GET",
            body: nil,
            addToken: true);
        
        if (response == nil || response?.body == nil) {
            return OrdersListResponse(orders: [], total: 0);
        }
        
        if let jsonString = String(data: response!.body!, encoding: .utf8) {
            print("=== RAW JSON ===")
            print(jsonString)
            print("================\n")
        } else {
            print("Failed to convert Data to UTF-8 String")
        }

        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            
            let result = try decoder.decode(OrdersListResponse.self, from: response!.body!)
            print("✅ Decoding successful!")
            
        } catch let DecodingError.keyNotFound(key, context) {
            print("❌ Missing Key: '\(key.stringValue)'")
            print("📍 Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            print("📝 Debug: \(context.debugDescription)")
            
        } catch let DecodingError.typeMismatch(type, context) {
            print("❌ Type Mismatch: Expected '\(type)'")
            print("📍 Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            print("📝 Debug: \(context.debugDescription)")
            
        } catch let DecodingError.valueNotFound(type, context) {
            print("❌ Null Value Found: Expected '\(type)' but found null")
            print("📍 Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            print("📝 Debug: \(context.debugDescription)")
            
        } catch let DecodingError.dataCorrupted(context) {
            print("❌ Data Corrupted")
            print("📍 Path: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))")
            print("📝 Debug: \(context.debugDescription)")
            
        } catch {
            print("❌ Unknown Error: \(error.localizedDescription)")
        }
        
         
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        let orders: OrdersListResponse = try decoder.decode(OrdersListResponse.self, from: (response?.body)!)
        
        return orders
        
    }
    
    /*
    public func AcceptRun(runId: Int) async throws -> Bool {
        
        var body = RunIdDto(run_id: runId)
        let bodydata = try? JSONEncoder().encode(body)
        
        let response: HttpRequestReponse? = await sendRequest(
            endpoint: "/api/v0/auth/accept",
            method: "GET",
            body: nil,
            addToken: true);
        
        if (response == nil) {
            return false ;
        }
        return response!.statusCode == 200
        
    }
     */
   
    
    
    
    
    
}
