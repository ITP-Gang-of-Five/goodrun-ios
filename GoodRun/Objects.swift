//
//  Objects.swift
//  GoodRun
//
//  Created by Max Healey on 16/8/2026.
//

import Foundation

public struct Location: Decodable, Equatable {
  let name: String
  let longitude: Double
  let latitude: Double
}

public enum RunSize: String, Decodable, Equatable {
  case small = "Small"
  case medium = "Medium"
  case large = "Large"
}

public enum RunUrgency: String, Decodable, Equatable {
  case low = "Low"
  case medium = "Medium"
  case high = "High"
}

public enum RunStatus: String, Decodable, Equatable {
  case low = "Low"
  case medium = "Medium"
  case high = "High"
}

@MainActor
public struct RunResponseDto: Decodable, Identifiable, Hashable, Equatable {
  public let id: Int
  public let name: String
  public let size: RunSize
  public let toLocation: Location
  public let fromLocation: Location
  public let status: RunStatus
  public let createdBy: String
  public let createdTime: Date  // Or String depending on your JSON parsing strategy
  public let urgency: RunUrgency
  public let assignedTo: [Int]
  public let expiryTime: Date?
  public let completedTime: Date?
  public let notes: String?

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case size
    case toLocation = "to_location"
    case fromLocation = "from_location"
    case status
    case createdBy
    case createdTime
    case urgency
    case assignedTo
    case expiryTime
    case completedTime
    case notes
  }

  func equals(to: RunResponseDto) -> Bool {
    return id == to.id
  }

  public func hash(into hasher: inout Hasher) {
    return id.hash(into: &hasher)
  }
}

public typealias Run = RunResponseDto

public struct RunIdDto: Encodable {
  public let runId: Int

  enum CodingKeys: String, CodingKey {
    case runId = "run_id"
  }
}
