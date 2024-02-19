//
//  MockURLSession.swift
//
//
//  Created by Essam Fahmy on 17/01/2024.
//

import Combine
import Foundation

@testable import NetworkingKit

class MockURLSession: URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return URLSession.DataTaskPublisher(request: request, session: session)
    }
}
