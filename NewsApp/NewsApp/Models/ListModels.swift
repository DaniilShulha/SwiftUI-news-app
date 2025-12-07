//
//  ListModels.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

enum ListItem: Identifiable, Hashable {
    case news(Article)
    case ad(AdBlock)

    var id: String {
        switch self {
        case .news(let article): return "n-\(article.id)"
        case .ad(let ad): return "a-\(ad.id)"
        }
    }
}
