//
//  GBLDataStorage.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import Foundation

class GBLDataStorage: GBLDataStorageProtocol {
    enum FilmKey: String {
        case favoritesKey = "GhibliExplorer.FavoriteFilms"
    }
    
    enum SettingsKey: String {
        case appearenceKey = "GhibliExplorer.Settings.Appearence"
        case usernameKey = "GhibliExplorer.Settings.Username"
        case pageSizeKey = "GhibliExplorer.Settings.PageSize"
        case enableNotificationKey = "GhibliExplorer.Settings.EnableNotification"
    }
    
    func save(_ favoriteIDs: [String]) {
        UserDefaults.standard.set(favoriteIDs, forKey: FilmKey.favoritesKey.rawValue)
    }
    
    func load() -> [String] {
        let array = UserDefaults.standard.array(forKey: FilmKey.favoritesKey.rawValue) as? [String] ?? []
        return array
    }
    
    private func saveValue<T: Encodable>(_ value: T?, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    private func loadValue<T: Decodable>(forKey key: String) -> T? {
        return UserDefaults.standard.value(forKey: key) as? T
    }
}

extension GBLDataStorage: GBLSettingsDataStorageProtocol {
    func saveAppearence(_ appearence: Int) {
        saveValue(appearence, forKey: SettingsKey.appearenceKey.rawValue)
    }
    
    func saveUsername(_ username: String?) {
        saveValue(username, forKey: SettingsKey.usernameKey.rawValue)
    }
    
    func savePageSize(_ pageSize: Int) {
        saveValue(pageSize, forKey: SettingsKey.pageSizeKey.rawValue)
    }
    
    func saveEnableNotification(_ isEnable: Bool) {
        saveValue(isEnable, forKey: SettingsKey.enableNotificationKey.rawValue)
    }
    
    func loadAppearence() -> Int {
        loadValue(forKey: SettingsKey.appearenceKey.rawValue) ?? SettingsDefaultValue.appearance.rawValue
    }
    
    func loadUsername() -> String? {
        loadValue(forKey: SettingsKey.usernameKey.rawValue) ?? SettingsDefaultValue.userName
    }
    
    func loadPageSize() -> Int {
        loadValue(forKey: SettingsKey.pageSizeKey.rawValue) ?? SettingsDefaultValue.itemsPerPage
    }
    
    func loadEnableNotification() -> Bool {
        loadValue(forKey: SettingsKey.enableNotificationKey.rawValue) ?? SettingsDefaultValue.notificationsEnabled
    }
}
