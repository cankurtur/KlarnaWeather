//
//  NetworkManagerTests.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import XCTest
@testable import KlarnaWeather

final class NetworkManagerTests: XCTestCase {
    
    private var sut: MockNetworkManager!
    
    private var weatherInfoResponseModel: WeatherInfoResponseModel?
    private var error: Error?
    
    private enum MockEndpoint: Endpoint {
        case mock
        
        var path: String {
            switch self {
            case .mock:
                return "/mock"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .mock:
                return .get
            }
        }
    }
    
    override func setUp() {
        super.setUp()
        sut = MockNetworkManager()
    }
    
    private func assumingMockDataLoadedSuccessfully() {
        LocalJSONLoader.shared.read(for: WeatherInfoResponseModel.self, withName: "MockWeatherInfoResponseModel") { (result) in
            switch result {
            case .success(let response):
                self.weatherInfoResponseModel = response
            case .failure(let error):
                self.error = error
            }
        }
        XCTAssertNil(error)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        weatherInfoResponseModel = nil
        error = nil
    }
    
    func test_request_success() async throws {
        // Given
        assumingMockDataLoadedSuccessfully()
        let mockResponse = weatherInfoResponseModel
        sut.mockResponse = mockResponse
        XCTAssertFalse(sut.isRequestCalled)
        // When
        let weatherInfoResponse = try await sut.request(endpoint: MockEndpoint.mock, responseType: WeatherInfoResponseModel.self)
        // Then
        XCTAssertTrue(sut.isRequestCalled)
        XCTAssertNil(sut.mockError)
        XCTAssertEqual(weatherInfoResponse.name, mockResponse?.name)
        XCTAssertEqual(weatherInfoResponse.main?.temp, mockResponse?.main?.temp)
    }
    
    func test_request_failure() async throws {
        // Given
        sut.mockError = NSError(domain: "MockError", code: 1, userInfo: nil)
        XCTAssertFalse(sut.isRequestCalled)
        do {
            // When
            _ = try await sut.request(endpoint: MockEndpoint.mock, responseType: WeatherInfoResponseModel.self)
        } catch let error {
            // Then
            XCTAssertTrue(sut.isRequestCalled)
            XCTAssertNil(sut.mockResponse)
            XCTAssertEqual(error as NSError, sut.mockError)
        }
    }
}
