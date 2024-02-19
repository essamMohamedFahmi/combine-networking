//
//  URLSessionAPIClientTests.swift
//
//
//  Created by Essam Fahmy on 17/01/2024.
//

import XCTest
import Combine

@testable import NetworkingKit

final class URLSessionAPIClientTests: XCTestCase {
    // MARK: Properties
    
    var apiClient: URLSessionAPIClient<OnboardingEndpoint>!

    // MARK: - Setup and TearDown
    
    override func setUp() {
        super.setUp()
        apiClient = URLSessionAPIClient<OnboardingEndpoint>(session: MockURLSession())
    }
    
    override func tearDown() {
        apiClient = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func test_request_success() throws {
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
        let expectation = XCTestExpectation(description: "Request done successfully!")
          
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        _ = apiClient.request(.register(email: "test@example.com", password: "password", name: "John Doe"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTFail("Unexpected failure: \(error)")
                }
            }, receiveValue: { (response: APIResponse<RemoteRegisterUser>) in
                // Then
                XCTAssertTrue(response.success)
                XCTAssertEqual(response.data, expectedUser)
                expectation.fulfill()
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
    
    func test_request_failure_customError() throws {
        // Given
        let expectation = XCTestExpectation(description: "Request failed!")
        MockURLProtocol.resetMockData()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 422, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        // When
        _ = apiClient.request(.register(email: "test@example.com", password: "password", name: "John Doe"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error, APIError.customError(statusCode: 422))
                    expectation.fulfill()
                }
            }, receiveValue: { (response: APIResponse<RemoteRegisterUser>) in
                XCTFail("Unexpected response \(response.success)")
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
    
    func test_request_failure_decodingFailed() throws {
        // Given
        let expectation = XCTestExpectation(description: "Request failed!")
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.decodingFailed = true

        // When
        _ = apiClient.request(.register(email: "test@example.com", password: "password", name: "John Doe"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error, APIError.decodingFailed)
                    expectation.fulfill()
                }
            }, receiveValue: { (response: APIResponse<RemoteRegisterUser>) in
                XCTFail("Unexpected response \(response.success)")
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
    
    func test_request_failure_requestFailed() throws {
        // Given
        let expectation = XCTestExpectation(description: "Request failed!")
        MockURLProtocol.resetMockData()
        MockURLProtocol.populateRequestHandler()
        MockURLProtocol.requestFailed = true

        // When
        _ = apiClient.request(.register(email: "test@example.com", password: "password", name: "John Doe"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case let .failure(error):
                    // Then
                    XCTAssertEqual(error, APIError.requestFailed)
                    expectation.fulfill()
                }
            }, receiveValue: { (response: APIResponse<RemoteRegisterUser>) in
                XCTFail("Unexpected response \(response.success)")
            })
        
        // Complete the expectation
        wait(for: [expectation], timeout: 1)
    }
}
