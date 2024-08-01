//
//  MockNetworkManager.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation
@testable import KlarnaWeather

final class MockNetworkManager: NetworkManagerInterface {
    
    var isRequestCalled: Bool = false
    var mockResponse: Codable?
    var mockError: NSError?
    
    func request<T>(endpoint: some Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
        isRequestCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let mockResponse = mockResponse else {
            throw NSError(domain: "MockError", code: 0, userInfo: nil)
        }
                
        return mockResponse as! T
    }
}
