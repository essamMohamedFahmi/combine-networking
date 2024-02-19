//
//  MockOnboardingServiceProvider.swift
//  
//
//  Created by Essam Fahmy on 16/01/2024.
//

import Foundation
import Combine
import NetworkingKit

class MockOnboardingServiceProvider: OnboardingService {
    var apiClient: MockAPIClient<OnboardingEndpoint>
    
    init(apiClient: MockAPIClient<OnboardingEndpoint>) {
        self.apiClient = apiClient
    }

    func register(email: String, password: String, name: String) -> AnyPublisher<APIResponse<RemoteRegisterUser>, APIError> {
        return apiClient.request(
            .register(email: email, password: password, name: name)
        )
    }
}
