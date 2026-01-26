//
//  FilmDetailProvider.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/22.
//

import RxSwift

protocol FilmDetailProviderProtocol {
    var favoriteManager: FavoriteManager { get }
    func fetchPerson(url: String) -> Single<Person>
}

class FilmDetailProvider: FilmDetailProviderProtocol {
    let favoriteManager: FavoriteManager
    private let apiManager: APIManager
    
    init(favoriteManager: FavoriteManager, apiManager: APIManager) {
        self.favoriteManager = favoriteManager
        self.apiManager = apiManager
    }
    
    func fetchPerson(url: String) -> Single<Person> {
        guard let personURL = URL(string: url) else {
            return .error(GBLError.model.convertPersonIDError(url: url))
        }
        let personID = personURL.lastPathComponent
#if DEBUG
        return apiManager.mockFetchPerson(id: personID)
#else
        return apiManager.fetchPerson(id: personID)
#endif
    }
}
