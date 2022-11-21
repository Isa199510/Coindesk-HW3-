//
//  NetworkManager.swift
//  Coindesk(HW3)
//
//  Created by Иса on 21.11.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch(from url: String, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                completion(.success(data))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
