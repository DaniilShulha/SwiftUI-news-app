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
    
    private let newsService = NewsService()
    private let adsService = AdsService() // Добавляем сервис для блоков
    private let adInsertInterval = 3 // Интервал вставки (каждая 3-я ячейка)
    
    // ... Тут будут Set'ы для избранного и заблокированного ...

    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 1. Параллельная загрузка (экономит время)
            async let fetchedNews = newsService.fetchNews()
            async let fetchedAds = adsService.fetchAds()
            
            let news = try await fetchedNews
            let ads = try await fetchedAds
            
            // 2. Логика фильтрации (Должна быть тут!)
            // Здесь мы должны отфильтровать новости, которые пользователь заблокировал.
            // Пока пропускаем этот шаг, чтобы сосредоточиться на слиянии.

            // 3. Слияние данных
            self.items = merge(news: news, ads: ads, interval: adInsertInterval)
            
        } catch {
            self.errorMessage = "Ошибка загрузки данных. Пожалуйста, проверьте подключение и Header авторизации. \(error.localizedDescription)"
        }
        
        isLoading = false
    }

    // Алгоритм слияния (переносим его прямо сюда, это часть бизнес-логики VM)
    private func merge(news: [Article], ads: [AdBlock], interval: Int) -> [ListItem] {
        guard !ads.isEmpty else {
            // Если нет рекламы, просто возвращаем новости
            return news.map { ListItem.news($0) }
        }
        
        var result: [ListItem] = []
        let totalAds = ads.count // Общее количество доступных рекламных блоков
        
        for (index, article) in news.enumerated() {
            // 1. Добавляем новость
            result.append(.news(article))
            
            // 2. Проверяем, пора ли вставлять блок
            // (index + 1) нужен, так как нумерация начинается с 0,
            // а вставка должна быть после 3-й, 6-й, 9-й и т.д. новости.
            if (index + 1) % interval == 0 {
                
                // ✅ CRITICAL FIX: Расчет циклического индекса
                // Используем оператор остатка от деления (%) для получения циклического индекса.
                let adIndex = (index + 1) / interval - 1
                let cyclicIndex = adIndex % totalAds
                
                // 3. Вставляем рекламный блок, используя циклический индекс
                result.append(.ad(ads[cyclicIndex]))
            }
        }
        
        // Блоки в конце ленты не добавляем, так как задача — чередовать их с новостями.
        return result
    }
}
