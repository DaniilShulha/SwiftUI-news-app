//
//  NewsModels.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let results: [Article]
}

struct Article: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let abstract: String
    let url: String
    let publishedDate: String
    let media: [ArticleMedia]?
    let section: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, abstract, url, media, section
        case publishedDate = "published_date"
    }
    
    var imageUrl: URL? {
        guard let mediaItems = media?.first?.mediaMetadata else { return nil }
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

struct ArticleMedia: Codable, Hashable {
    let mediaMetadata: [MediaMetadata]
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Codable, Hashable {
    let url: String
    let height: Int
    let width: Int
}

