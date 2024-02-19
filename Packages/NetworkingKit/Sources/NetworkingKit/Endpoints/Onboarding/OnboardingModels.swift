//
//  OnboardingModels.swift
//
//
//  Created by Essam Fahmy on 14/01/2024.
//

import Foundation

// MARK: - Remote Models

public struct RemoteRegisterUser: Codable, Equatable {
    public let id, email, name: String?
    public let legalAge: Bool?
    public let signUpStep: Int?
    
    public init(id: String?, email: String?, name: String?, legalAge: Bool?, signUpStep: Int?) {
        self.id = id
        self.email = email
        self.name = name
        self.legalAge = legalAge
        self.signUpStep = signUpStep
    }
}

// MARK: - Request Models

struct RegisterRequestBody: Encodable {
    let email: String
    let password: String
    let name: String
}
