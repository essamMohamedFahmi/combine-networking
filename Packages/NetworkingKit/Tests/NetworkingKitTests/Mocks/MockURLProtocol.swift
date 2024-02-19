//
//  MockURLProtocol.swift
//
//
//  Created by Essam Fahmy on 17/01/2024.
//

import Combine
import Foundation

@testable import NetworkingKit

class MockURLProtocol: URLProtocol {
    // MARK: - Mocking Data

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    static var requestFailed = false
    static var decodingFailed = false
        
    static func resetMockData() {
        requestHandler = nil
        requestFailed = false
        decodingFailed = false
    }
    
    /// Avoid fatalError("Handler is unavailable.")
    static func populateRequestHandler() {
        requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "http://example.com")!, statusCode: 0, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
    }

    // MARK: - Class Methods

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        do {
            guard let handler = MockURLProtocol.requestHandler else {
                fatalError("Handler is unavailable.")
            }

            if MockURLProtocol.decodingFailed {
                throw NSError(domain: "com.example.errorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Simulated generic error"])
            }
            
            let (response, data) = try handler(request)
            
            if MockURLProtocol.requestFailed {
                client?.urlProtocol(self, didReceive: URLResponse(), cacheStoragePolicy: .notAllowed)
            } else {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        //
    }
}
