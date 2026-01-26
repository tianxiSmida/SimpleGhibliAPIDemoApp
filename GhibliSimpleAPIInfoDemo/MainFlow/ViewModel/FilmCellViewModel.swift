//
//  FilmCellViewModel.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/16.
//

import RxSwift
import RxRelay

class FilmCellViewModel {
    
    struct Input {
        let tapFavorite: Observable<Void>
    }
    
    struct Output {
        let isFavorite: Observable<Bool>
        let id: String
        let title: String
        let director: String
        let releaseYear: String
        let image: String
    }
    
    let model: Film
    private let favoriteManager: FavoriteManager
    private let isFavoriteRelay: BehaviorRelay<Bool>
    private let disposeBag = DisposeBag()
    private var actionDisposeBag = DisposeBag()
    
    init(favoriteManager: FavoriteManager, model: Film) {
        self.favoriteManager = favoriteManager
        self.model = model
        self.isFavoriteRelay = BehaviorRelay(value: favoriteManager.hasInFavoriteList(model.id))
        subscribeFavoriteList()
    }
    
    func transform(input: Input) -> Output {
        actionDisposeBag = .init()
        
        let modelID = model.id
        let favoriteManager = self.favoriteManager
        
        input.tapFavorite
            .withLatestFrom(isFavoriteRelay)
            .subscribe(onNext: { isAdd in
                if isAdd {
                    favoriteManager.removeToFavorite(id: modelID)
                } else {
                    favoriteManager.addToFavorite(id: modelID)
                }
            })
            .disposed(by: actionDisposeBag)
            
        return Output(
            isFavorite: isFavoriteRelay.asObservable(),
            id: model.id,
            title: model.title,
            director: model.director,
            releaseYear: model.releaseYear,
            image: model.image
        )
    }
    
    private func subscribeFavoriteList() {
        favoriteManager.registerFavoriteState(id: model.id)
            .bind(to: isFavoriteRelay)
            .disposed(by: disposeBag)
    }
}
