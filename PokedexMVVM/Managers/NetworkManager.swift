//
//  NetworkManager.swift
//  PokedexMVVM
//
//  Created by Iuri Ferreira on 6/11/25.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case unknown
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
