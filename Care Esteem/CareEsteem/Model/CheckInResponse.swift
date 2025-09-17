//
//  CheckInResponse.swift
//  CareEsteem
//
//  Created by Amit Saini on 01/09/25.
//


import Foundation

// MARK: - API Response
struct CheckInResponse: Codable {
    let statusCode: Int
    let message: String
    let data: CheckInDataResponse?
}

// MARK: - Data Object
struct CheckInDataResponse: Codable {
    let id: String
    let agencyID: String
    let clientID: String
    let visitDetailsID: String
    let userID: String
    let actualStartTime: String
    let actualEndTime: String?
    let status: String?
    let createdAt: String
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case agencyID = "agency_id"
        case clientID = "client_id"
        case visitDetailsID = "visit_details_id"
        case userID = "user_id"
        case actualStartTime = "actual_start_time"
        case actualEndTime = "actual_end_time"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}