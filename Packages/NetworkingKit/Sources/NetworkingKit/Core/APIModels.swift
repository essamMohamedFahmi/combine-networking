//
//  APIModels.swift
//
//
//  Created by Essam Fahmy on 14/01/2024.
//

import Foundation

// MARK: - APIResponse

public struct APIResponse<T: Codable>: Codable {
    public let status: String
    public let data: T?
    
    public init(status: String, data: T?) {
        self.status = status
        self.data = data
    }
}

extension APIResponse {
    public var success: Bool {
        status == "success"
    }
}

// MARK: - APIErorr

public enum APIError: Error, Equatable {
    case requestFailed
    case decodingFailed
    case customError(statusCode: Int)
}
