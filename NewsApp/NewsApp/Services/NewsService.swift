//
//  NewsService.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

actor NewsService {
    private let authHeaderValue = "Daniil-Shulha"
    
    func fetchNews(period: Int = 30) async throws -> [Article] {
        var components = URLComponents(string: "https://us-central1-server-side-functions.cloudfunctions.net/nytimes")
        components?.queryItems = [
            URLQueryItem(name: "period", value: "\(period)")
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            return decodedResponse.results
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
