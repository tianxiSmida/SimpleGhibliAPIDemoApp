//
//  FavoriteManager.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/15.
//

import RxSwift

class FavoriteManager {
    
    private enum Operation {
        case add
        case remove
    }
    
    private let storage: GBLDataStorageProtocol
    private let changeSubject: PublishSubject<(String, FavoriteManager.Operation)> = .init()
    private var favorityList: [String]
    
    init(storage: GBLDataStorageProtocol) {
        self.storage = storage
        self.favorityList = storage.load()
    }
    
    func addToFavorite(id: String) {
        favorityList.append(id)
        changeSubject.onNext((id, .add))
        storage.save(favorityList)
    }
    
    func removeToFavorite(id: String) {
        favorityList.removeAll(where: { $0 == id })
        changeSubject.onNext((id, .remove))
        storage.save(favorityList)
    }
    
    /// return isInFavoriteList
    func registerFavoriteState(id: String) -> Observable<Bool> {
        return Observable.merge(
            Observable.just(hasInFavoriteList(id)), // init
            changeSubject.filter { $0.0 == id }.map { $0.1 == .add } // change notify
        )
    }
    
    private func hasInFavoriteList(_ id: String) -> Bool {
        return favorityList.contains(id)
    }
}
