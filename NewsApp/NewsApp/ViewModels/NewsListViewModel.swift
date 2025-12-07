//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import Foundation
import SwiftUI

@MainActor
class NewsListViewModel: ObservableObject {
    @Published var items: [ListItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var favoriteIds: Set<Int> = []
    @Published var blockedIds: Set<Int> = []
    
    @Published var articleToUnblock: Article? = nil
    
    @Published var currentCategory: ContentView.NewsCategory = .all
    
    private let newsService = NewsService()
    private let adsService = AdsService()
    private let adInsertInterval = 3
        
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        self.favoriteIds = PersistenceManager.shared.loadFavorites()
        self.blockedIds = PersistenceManager.shared.loadBlocked()
        
        do {
            async let fetchedNews = newsService.fetchNews()
            async let fetchedAds = adsService.fetchAds()
            
            let news = try await fetchedNews
            let ads = try await fetchedAds
            
            self.items = merge(news: news, ads: ads, interval: adInsertInterval)
            
        } catch {
            self.errorMessage = "Ошибка загрузки данных. Пожалуйста, проверьте подключение и Header авторизации. \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleFavorite(articleId: Int) {
        if favoriteIds.contains(articleId) {
            favoriteIds.remove(articleId)
        } else {
            favoriteIds.insert(articleId)
        }
        PersistenceManager.shared.saveFavorites(favoriteIds)
    }
    
    func toggleBlocked(articleId: Int) {
        if blockedIds.contains(articleId) {
            blockedIds.remove(articleId)
        } else {
            blockedIds.insert(articleId)
            favoriteIds.remove(articleId)
            PersistenceManager.shared.saveFavorites(favoriteIds)
        }
        PersistenceManager.shared.saveBlocked(blockedIds)
    }
    
    func items(for category: ContentView.NewsCategory) -> [ListItem] {
        switch category {
        case .all:
            return items.filter { item in
                switch item {
                case .news(let article):
                    return !blockedIds.contains(article.id)
                case .ad:
                    return true
                }
            }
        case .favorite:
            return items.filter { item in
                switch item {
                case .news(let article):
                    return favoriteIds.contains(article.id)
                case .ad:
                    return false
                }
            }
        case .blocked:
            return items.filter { item in
                switch item {
                case .news(let article):
                    return blockedIds.contains(article.id)
                case.ad:
                    return false
                }
            }
            
        }
        
    }
    
    private func merge(news: [Article], ads: [AdBlock], interval: Int) -> [ListItem] {
        guard !ads.isEmpty else {
            return news.map { ListItem.news($0) }
        }
        
        var result: [ListItem] = []
        let totalAds = ads.count
        
        for (index, article) in news.enumerated() {
            result.append(.news(article))
            
            if (index + 1) % interval == 0 {
                
                let adIndex = (index + 1) / interval - 1
                let cyclicIndex = adIndex % totalAds
                
                result.append(.ad(ads[cyclicIndex]))
            }
        }
        
        return result
    }
}
