//
//  PersistenceManager.swift
//  NewsApp
//
//  Created by kSenexie on 7.12.25.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let favoritesKey = "favorites_ids"
    private let blockedKey = "blocked_ids"
    
    private init() {}
    
    func saveFavorites(_ ids: Set<Int>) {
        let array = Array(ids)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }
    
    func saveBlocked(_ ids: Set<Int>) {
        let array = Array(ids)
        UserDefaults.standard.set(array, forKey: blockedKey)
    }
    
    
    func loadFavorites() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        return Set(array)
    }
    
    func loadBlocked() -> Set<Int> {
        let array = UserDefaults.standard.array(forKey: blockedKey) as? [Int] ?? []
        return Set(array)
    }
}
