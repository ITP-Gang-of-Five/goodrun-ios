//
//  Enums.swift
//  GoodRun
//
//  Created by Max Healey on 25/9/2026.
//

import Foundation

enum Role: String, Codable {
    case admin = "ADMIN"
    case volunteer = "VOLUNTEER"
    case organisation = "ORGANISATION"
}

enum RunStatus: String, Codable {
    case notStarted = "NOT_STARTED"
    case inProgress = "IN_PROGRESS"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

enum OrderStatus: String, Codable {
    case pending = "PENDING"
    case readyForPickup = "READY_FOR_PICKUP"
    case inTransit = "IN_TRANSIT"
    case delivered = "DELIVERED"
    case cancelled = "CANCELLED"
}

enum Urgency: String, Codable {
    case low = "LOW"
    case medium = "MEDIUM"
    case high = "HIGH"
}

enum CarSize: String, Codable {
    case small = "SMALL"
    case medium = "MEDIUM"
    case large = "LARGE"
}

enum ApiErrorCode: String, Codable {
    case runNotFound = "RUN_NOT_FOUND"
    case orderAlreadyTaken = "ORDER_ALREADY_TAKEN"
    case runNotAssigned = "RUN_NOT_ASSIGNED"
    case orderNotAvailable = "ORDER_NOT_AVAILABLE"
    case orderTooLarge = "ORDER_TOO_LARGE"
    case runNotInProgress = "RUN_NOT_IN_PROGRESS"
    case orderNotFound = "ORDER_NOT_FOUND"
    case locationNotFound = "LOCATION_NOT_FOUND"
    case organisationNotFound = "ORGANISATION_NOT_FOUND"
    case invalidRun = "INVALID_RUN"
    case invalidOrder = "INVALID_ORDER"
    case trackingUnavailable = "TRACKING_UNAVAILABLE"
    case invalidCredentials = "INVALID_CREDENTIALS"
    case addressNotFound = "ADDRESS_NOT_FOUND"
    case emailAlreadyInUse = "EMAIL_ALREADY_IN_USE"
    case validationError = "VALIDATION_ERROR"
    case volunteerNotFound = "VOLUNTEER_NOT_FOUND"
}
