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
