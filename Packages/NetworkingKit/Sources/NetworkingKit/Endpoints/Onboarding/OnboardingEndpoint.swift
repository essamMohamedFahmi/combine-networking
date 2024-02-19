//
//  OnboardingEndpoint.swift
//
//
//  Created by Essam Fahmy on 14/01/2024.
//

import Foundation

public enum OnboardingEndpoint: APIEndpoint {
    case register(email: String, password: String, name: String)

    public var baseURL: URL {
        // TODO: - Confirm an approach to secure your keys
        // TODO: - Integrate different environments
        return URL(
            string: "https://dev.mobile-service.com"
        )!
    }

    public var path: String {
        switch self {
        case .register:
            return "/v1/registration/register"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        }
    }

    public var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        return headers
    }

    public var body: Data? {
        switch self {
        case let .register(email, password, name):
            let requestBody = RegisterRequestBody(email: email, password: password, name: name)
            return try? JSONEncoder().encode(requestBody)
        }
    }
}
