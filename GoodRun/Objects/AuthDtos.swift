//
//  Enums.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import Foundation

package struct LoginRequest: Codable {
    let email: String
    let password: String
}

package struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let user: UserSummary
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}

package struct RefreshTokenRequest: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

package struct RefreshTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
