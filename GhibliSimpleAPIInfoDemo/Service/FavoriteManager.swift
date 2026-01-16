//
//  FavoriteManager.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/15.
//

import RxSwift
import RxRelay

class FavoriteManager {
    
    private enum Operation {
        case add
        case remove
    }
    
    private let storage: GBLDataStorageProtocol
    private let changeSubject: PublishSubject<(String, FavoriteManager.Operation)> = .init()
    private let favorityListSubject: BehaviorRelay<[String]> = .init(value: [])
    
    var favorityList: Observable<[String]> {
        return favorityListSubject.asObservable()
    }
    
    init(storage: GBLDataStorageProtocol) {
        self.storage = storage
        self.favorityListSubject.accept(storage.load())
    }
    
    func addToFavorite(id: String) {
        var newFavorityList: [String] = favorityListSubject.value
        newFavorityList.append(id)
        favorityListSubject.accept(newFavorityList)
        changeSubject.onNext((id, .add))
        storage.save(favorityListSubject.value)
    }
    
    func removeToFavorite(id: String) {
        var newFavorityList: [String] = favorityListSubject.value
        newFavorityList.removeAll(where: { $0 == id })
        favorityListSubject.accept(newFavorityList)
        changeSubject.onNext((id, .remove))
        storage.save(favorityListSubject.value)
    }
    
    /// return isInFavoriteList
    func registerFavoriteState(id: String) -> Observable<Bool> {
        return Observable.merge(
            Observable.just(hasInFavoriteList(id)), // init
            changeSubject.filter { $0.0 == id }.map { $0.1 == .add } // change notify
        )
    }
    
    private func hasInFavoriteList(_ id: String) -> Bool {
        return favorityListSubject.value.contains(id)
    }
}
