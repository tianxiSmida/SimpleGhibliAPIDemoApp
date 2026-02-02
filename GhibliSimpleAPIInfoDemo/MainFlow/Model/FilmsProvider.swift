//
//  FilmsProvider.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/16.
//

import RxSwift
import RxRelay

protocol FilmsProviderProtocol {
    var favoriteManager: FavoriteManager { get }
    func fetchFilms() -> Observable<[Film]>
}

class FilmsProvider {
    private let apiManager: APIManager
    let favoriteManager: FavoriteManager
    
    private let filmsSubject = BehaviorRelay<[Film]>(value: [])
    private let disposeBag = DisposeBag()
    
    init(apiManager: APIManager, favoriteManager: FavoriteManager) {
        self.apiManager = apiManager
        self.favoriteManager = favoriteManager
    }
    
    func fetchFilms() -> Observable<[Film]> {
        apiManager.fetchFilms()
            .do(onSuccess: filmsSubject.accept(_:))
            .asObservable()
    }
}

extension FilmsProvider {
    
    struct FilmsProviderWrapper: FilmsProviderProtocol {
        var favoriteManager: FavoriteManager
        let film: Observable<[Film]>
        func fetchFilms() -> Observable<[Film]> {
            return film
        }
    }
    
    func createFilmListProvider() -> FilmsProviderProtocol {
        FilmsProviderWrapper(
            favoriteManager: favoriteManager,
            film: fetchFilms()
        )
    }
    
    func createFavirateFilmListProvider() -> FilmsProviderProtocol {
        FilmsProviderWrapper(
            favoriteManager: favoriteManager,
            film: Observable
                .combineLatest(favoriteManager.favorityList, filmsSubject)
                .map { (list, films) in
                    let dict = Dictionary(uniqueKeysWithValues: films.map { ($0.id, $0) })
                    return list.compactMap { dict[$0] }
                }
        )
    }
}
