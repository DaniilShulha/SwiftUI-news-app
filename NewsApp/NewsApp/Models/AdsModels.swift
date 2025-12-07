//
//  AdModels.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

struct AdBlocksResponse: Codable {
    let results: [AdBlock]
}

struct AdBlock: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String?
    let titleSymbol: String?
    let buttonTitle: String?
    let buttonSymbol: String?
    
   enum CodingKeys: String, CodingKey {
        case id, title, subtitle
        case buttonTitle = "button_title"
        case titleSymbol = "title_symbol"
        case buttonSymbol = "button_symbol"
    }
}
