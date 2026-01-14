//
//  GBLDataStorage.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import Foundation

class GBLDataStorage: GBLDataStorageProtocol {
    private let favoritesKey = "GhibliExplorer.FavoriteFilms"
    
    func save(_ favoriteIDs: [String]) {
        UserDefaults.standard.set(favoriteIDs, forKey: favoritesKey)
    }
    
    func load() -> [String] {
        let array = UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
        return array
    }
}
