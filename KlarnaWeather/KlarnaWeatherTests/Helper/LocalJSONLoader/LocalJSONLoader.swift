//
//  LocalJSONLoader.swift
//  KlarnaWeatherTests
//
//  Created by Can Kurtur on 1.08.2024.
//

import Foundation

final class LocalJSONLoader {
    private enum LocalJSONLoaderError: Error {
        case pathNotFound
        case contentOfFileCannotConvertedToString
        case jsonDataCannotCreated
        case jsonDecodingFailed
    }
    
    typealias JSONCompletionForNetworking<T> = (Result<T, Error>) -> Void where T: Decodable
    private let kJsonFileType = "json"

    static let shared = LocalJSONLoader()
    
    private init () { }
    
    func read<T: Decodable>(for responseType: T.Type, withName name: String, bundle: Bundle = Bundle(for: LocalJSONLoader.self), completion: @escaping JSONCompletionForNetworking<T>) {
        guard let path = bundle.path(forResource: name, ofType: kJsonFileType) else {
            completion(.failure(LocalJSONLoaderError.pathNotFound))
            return
        }
        guard let jsonString = try? String(contentsOfFile: path) else { 
            completion(.failure(LocalJSONLoaderError.contentOfFileCannotConvertedToString))
            return
        }
        guard let jsonData = jsonString.data(using: .utf8) else { 
            completion(.failure(LocalJSONLoaderError.jsonDataCannotCreated))
            return
        }
        guard let decodedObject = try? JSONDecoder().decode(T.self, from: jsonData) else {
            completion(.failure(LocalJSONLoaderError.jsonDecodingFailed))
            return
        }
        completion(.success(decodedObject))
    }
}
