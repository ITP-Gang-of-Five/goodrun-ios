//
//
//  Enums.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: UserSummary
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
