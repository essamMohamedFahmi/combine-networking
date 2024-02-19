//
//  RegistrationViewModelTests.swift
//
//
//  Created by Essam Fahmy on 16/01/2024.
//

import XCTest
import Combine
import NetworkingKit

@testable import CombineNetworking

final class RegistrationViewModelTests: XCTestCase {
    // MARK: Properties

    var viewModel: RegistrationViewModel!
    var mockAPIClient: MockAPIClient<OnboardingEndpoint>!
    
    // MARK: - Setup and TearDown

    override func setUp() {
        super.setUp()
        
        mockAPIClient = MockAPIClient<OnboardingEndpoint>()
        let onboardingService = MockOnboardingServiceProvider(apiClient: mockAPIClient)
        viewModel = RegistrationViewModel(onboardingService: onboardingService)
    }

    override func tearDown() {
        mockAPIClient = nil
        viewModel = nil

        super.tearDown()
    }

    // MARK: - Test Cases
    
    func test_register_success() throws {
        // Given
        let expectedUser = RemoteRegisterUser(
            id: "123",
            email: "example@example.com",
            name: "John Doe",
            legalAge: true,
            signUpStep: 1
        )
        
        let expectedAPIResponse = APIResponse(status: "success", data: expectedUser)
        let data = try XCTUnwrap(JSONEncoder().encode(expectedAPIResponse))
        mockAPIClient.requestResult = .success(data)
       
        // When
        viewModel.email = "test@example.com"
        viewModel.name = "John Doe"
        viewModel.password = "password"
        viewModel.register()
        
        // Then
        waitUntil(viewModel.$registrationResult, equals: .success(username: "John Doe"))
    }
    
    func test_register_success_usernameNotFound() throws {
        // Given
        let expectedUser = RemoteRegisterUser(
            id: "123",
            email: "example@example.com",
            name: nil,
            legalAge: true,
            signUpStep: 1
        )
        
        let expectedAPIResponse = APIResponse(status: "success", data: expectedUser)
        let data = try XCTUnwrap(JSONEncoder().encode(expectedAPIResponse))
        mockAPIClient.requestResult = .success(data)
       
        // When
        viewModel.email = "test@example.com"
        viewModel.name = "John Doe"
        viewModel.password = "password"
        viewModel.register()
        
        // Then
        waitUntil(viewModel.$registrationResult, equals: .failure(message: "Not Found"))
    }
    
    func test_register_failure() throws {
        // Given
        mockAPIClient.requestResult = .failure(.customError(statusCode: 422))
       
        // When
        viewModel.email = "test@example.com"
        viewModel.name = "John Doe"
        viewModel.password = "password"
        viewModel.register()
        
        // Then
        waitUntil(viewModel.$registrationResult, equals: .failure(message: APIError.customError(statusCode: 422).localizedDescription))
    }
}
