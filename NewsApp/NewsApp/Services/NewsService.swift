//
//  NewsService.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

// Ошибки, которые могут возникнуть
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

actor NewsService {
    // Твое имя для авторизации (Замени на свои данные!)
    private let authHeaderValue = "Daniil-Shulha"
    
    func fetchNews(period: Int = 30) async throws -> [Article] {
        // 1. Собираем URL с Query Parameter
        var components = URLComponents(string: "https://us-central1-server-side-functions.cloudfunctions.net/nytimes")
        components?.queryItems = [
            URLQueryItem(name: "period", value: "\(period)")
        ]
        
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        
        // 2. Настраиваем Request + Header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        
        // 3. Делаем запрос (iOS 15+)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 4. Проверяем статус код (200 OK)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // 5. Декодируем
        do {
            let decodedResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            return decodedResponse.results
        } catch {
            print("Decoding error: \(error)") // Полезно для отладки
            throw NetworkError.decodingError
        }
    }
}
