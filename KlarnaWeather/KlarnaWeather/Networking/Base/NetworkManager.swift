//
//  NetworkingManager.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - NetworkManagerProtocol

protocol NetworkManagerInterface {
    func request<T: Decodable>(endpoint: some Endpoint, responseType: T.Type) async throws -> T
}


// MARK: - NetworkManager

/// Network manager that provides request methods with async/await.
final class NetworkManager: NetworkManagerInterface {
    let session: URLSession
    
    /// Timeout interval per each request.
    private let timeoutInterval: TimeInterval
    
    /// Provides status codes for success cases, it is used to check if request failed or not.
    private var successStatusCodes: ClosedRange<Int> {
        return 200...209
    }
    
    /// Default, single, decoder for all of the requests.
    private lazy var decoder: JSONDecoder = {
        return .init()
    }()
    
    init(
        session: URLSession = .shared,
        timeoutInterval: TimeInterval = 10
    ) {
        self.session = session
        self.timeoutInterval = timeoutInterval
    }
    
    /// Sends request with new async/await API.
    /// - Parameters:
    ///   - endpoint: Given endpoint.
    ///   - responseType: Response type provided by consumer.
    /// - Returns: Decoded T type object.
    func request<T>(endpoint: some Endpoint, responseType: T.Type) async throws -> T where T : Decodable {
        guard let request = RequestBuilder.makeRequest(endpoint: endpoint, timeoutInterval: timeoutInterval) else {
            throw APIClientError.badRequest
        }
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let statusCode = response.code else {
                throw APIClientError.invalidStatusCode
            }
            if successStatusCodes.contains(statusCode) {
                return try await handleSucceedRequest(from: data, endpoint: endpoint, responseType: responseType)
            } else {
                throw await handleFailedRequest(from: response, data: data, endpoint: endpoint)
            }
        } catch let error as NSError {
            throw error
        }
    }
}

// MARK: - Handle Response

private extension NetworkManager {
    /// Handles success case from API request.
    func handleSucceedRequest<T: Decodable>(from data: Data, endpoint: some Endpoint, responseType: T.Type) async throws -> T where T: Decodable {
        guard !data.isEmpty else {
            return EmptyResponse() as! T
        }
        do {
            let decodedObject = try self.decoder.decode(responseType, from: data)
            return decodedObject
        } catch {
            let decodingError = APIClientError.decoding(error: error as? DecodingError)
            throw decodingError
        }
    }
    
    /// Handles failure case from API request.
    func handleFailedRequest(from response: URLResponse, data: Data?, endpoint: some Endpoint) async -> APIClientError {
        guard response.code != NSURLErrorTimedOut else {
            return APIClientError.timeout
        }
        do {
            guard let data = data else {
                return APIClientError.networkError
            }
            let clientError = try self.decoder.decode(ClientError.self, from: data)
            return APIClientError.handledError(apiError: clientError)
        } catch {
            let decodingError = APIClientError.decoding(error: error as? DecodingError)
            return decodingError
        }
    }
}
