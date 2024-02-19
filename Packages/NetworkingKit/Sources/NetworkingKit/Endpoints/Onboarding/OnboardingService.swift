//
//  OnboardingService.swift
//
//
//  Created by Essam Fahmy on 14/01/2024.
//

import Combine
import Foundation

// MARK: - OnboardingService

public protocol OnboardingService {
    func register(email: String, password: String, name: String) -> AnyPublisher<APIResponse<RemoteRegisterUser>, APIError>
}

// MARK: - OnboardingServiceProvider

public class OnboardingServiceProvider: OnboardingService {
    private let apiClient = URLSessionAPIClient<OnboardingEndpoint>()

    public init() {
        // To be accessible outside the package
    }
    
    public func register(email: String, password: String, name: String) -> AnyPublisher<APIResponse<RemoteRegisterUser>, APIError> {
        return apiClient.request(
            .register(email: email, password: password, name: name)
        )
    }
}
