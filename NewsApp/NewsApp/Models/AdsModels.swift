//
//  AdModels.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

// Контейнер для ответа от сервера (просто массив в корне)
struct AdBlocksResponse: Codable {
    let results: [AdBlock]
}

// Сам дополнительный блок (Supplementary Block)
struct AdBlock: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String?
    let titleSymbol: String? // SF Symbol для заголовка
    let buttonTitle: String?
    let buttonSymbol: String? // SF Symbol для кнопки
    
   
    
    // Для удобства маппинга JSON -> Swift (camelCase)
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle
        case buttonTitle = "button_title"
        case titleSymbol = "title_symbol"
        case buttonSymbol = "button_symbol"
    }
}
