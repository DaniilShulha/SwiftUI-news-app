//
//  NewsModels.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

// Общий ответ от сервера
struct NewsResponse: Codable {
    let status: String
    let results: [Article]
}

// Сама статья
struct Article: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let abstract: String
    let url: String // Ссылка на полную статью
    let publishedDate: String
    let media: [ArticleMedia]?
    let section: String
    
    // Для удобства маппинга JSON -> Swift (camelCase)
    enum CodingKeys: String, CodingKey {
        case id, title, abstract, url, media, section
        case publishedDate = "published_date"
    }
    
    // Хелпер: достать картинку лучшего качества
    var imageUrl: URL? {
        guard let mediaItems = media?.first?.mediaMetadata else { return nil }
        // Берем картинку с самым большим разрешением (обычно последняя в массиве)
        return URL(string: mediaItems.last?.url ?? "")
    }
    
    static let template = Article(
        id: 1,
        title: "Тестовый тайтл для новости",
        abstract: "Краткий обзор статьи, для проверки",
        url: "https://www.nytimes.com/2025/04/18/business/trump-harvard-letter-mistake.html",
        publishedDate: "2025-04-18",
        media: [
            ArticleMedia(mediaMetadata: [MediaMetadata(
                url: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-thumbStandard.jpg",
                height: 75,
                width: 75)])
        ],
        section: "Culture"
    )
}

// Медиа-контейнер
struct ArticleMedia: Codable, Hashable {
    let mediaMetadata: [MediaMetadata]
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

// Метаданные картинки
struct MediaMetadata: Codable, Hashable {
    let url: String
    let height: Int
    let width: Int
}

