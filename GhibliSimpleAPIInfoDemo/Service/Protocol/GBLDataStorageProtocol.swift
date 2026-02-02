//
//  GBLDataStorageProtocol.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import Foundation

public protocol GBLDataStorageProtocol {
    func save(_ favoriteIDs: [String])
    func load() -> [String]
}

public protocol GBLSettingsDataStorageProtocol {
    func saveAppearence(_ appearence: Int)
    func saveUsername(_ username: String?)
    func savePageSize(_ pageSize: Int)
    func saveEnableNotification(_ isEnable: Bool)
    
    func loadAppearence() -> Int
    func loadUsername() -> String?
    func loadPageSize() -> Int
    func loadEnableNotification() -> Bool
}
