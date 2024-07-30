//
//  Errors.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import Foundation

// MARK: - APIError

protocol APIError: Codable, AnyObject {
    var message: String { get }
    var statusCode: Int? { get set }
}

// MARK: - ClientError

class ClientError: APIError {
    var message: String
    var statusCode: Int?
}

// MARK: - APIClientError

enum APIClientError: Error {
    case handledError(apiError: APIError)
    case networkError
    case decoding(error: DecodingError?)
    case timeout
    case invalidStatusCode
    case badRequest
    
    var message: String {
        switch self {
        case .handledError(let apiError):
            return apiError.message
        case .networkError:
            return "Connection Error"
        case .decoding(let decodingError):
            guard let decodingError = decodingError else { return "Decoding Error" }
            return "\(decodingError)"
        case .timeout:
            return "Timeout"
        case .invalidStatusCode:
            return "Invalid Status Code"
        case .badRequest:
            return "Bad Request"
        }
    }
    
    var statusCode: Int {
        switch self {
        case .handledError(let apiError):
            return apiError.statusCode ?? 0
        case .networkError:
            return 400
        case .decoding:
            return NSURLErrorCannotDecodeRawData
        case .timeout:
            return NSURLErrorTimedOut
        case .invalidStatusCode:
            return 0
        case .badRequest:
            return 0
        }
    }
}
