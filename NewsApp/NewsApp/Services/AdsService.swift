//
//  AdsService.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

// Используем те же ошибки, что и в NewsService

actor AdsService {
    // Твое имя для авторизации (Замени на свои данные!)
    private let authHeaderValue = "Daniil-Shulha" // !!! ОБЯЗАТЕЛЬНО ЗАМЕНИ !!!
    
    func fetchAds() async throws -> [AdBlock] {
        guard let url = URL(string: "https://us-central1-server-side-functions.cloudfunctions.net/supplementary") else {
            throw NetworkError.invalidURL
        }
        
        // Настраиваем Request + Header
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authHeaderValue, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // Декодируем (обрати внимание, что декодируем AdBlocksResponse)
        do {
            let decodedResponse = try JSONDecoder().decode(AdBlocksResponse.self, from: data)
            return decodedResponse.results
        } catch {
            print("Ads Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}
