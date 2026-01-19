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
        let description: String
        let director: String
        let producer: String
        let releaseYear: String
        let score: String
        let duration: String
        let image: String
        let bannerImage: String
        let people: [String]
    }
    
    private let favoriteManager: FavoriteManager
    private let model: Film
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
            description: model.description,
            director: model.director,
            producer: model.producer,
            releaseYear: model.releaseYear,
            score: model.description,
            duration: model.duration,
            image: model.image,
            bannerImage: model.bannerImage,
            people: model.people
        )
    }
    
    private func subscribeFavoriteList() {
        favoriteManager.registerFavoriteState(id: model.id)
            .bind(to: isFavoriteRelay)
            .disposed(by: disposeBag)
    }
}
