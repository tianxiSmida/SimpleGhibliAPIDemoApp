//
//  FilmDetailViewModel.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/22.
//

import RxSwift
import RxCocoa

class FilmDetailViewModel {
    
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
        let people: Observable<[Person]>
        let isLoading: Observable<Bool>
    }
    
    struct EventOutput {
        let error: Observable<Error>
    }
    
    let model: Film
    lazy var eventOutput: EventOutput = . init(error: errorRelay.asObservable())
    private let provider: FilmDetailProviderProtocol
    private let isFavoriteRelay: BehaviorRelay<Bool>
    private let peopleRelay: BehaviorRelay<[Person]> = .init(value: [])
    private let isLoadingRelay: BehaviorRelay<Bool> = .init(value: false)
    private let errorRelay: PublishRelay<Error> = .init()
    private let disposeBag = DisposeBag()
    private var actionDisposeBag = DisposeBag()
    
    init(provider: FilmDetailProviderProtocol, model: Film) {
        self.provider = provider
        self.model = model
        self.isFavoriteRelay = BehaviorRelay(value: provider.favoriteManager.hasInFavoriteList(model.id))
        subscribeFavoriteList()
        fetchPeople()
    }
    
    func transform(input: Input) -> Output {
        actionDisposeBag = .init()
        
        let modelID = model.id
        let favoriteManager = provider.favoriteManager
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
            score: model.score,
            duration: model.duration,
            image: model.image,
            bannerImage: model.bannerImage,
            people: peopleRelay.asObservable(),
            isLoading: isLoadingRelay.asObservable()
        )
    }
    
    private func subscribeFavoriteList() {
        provider.favoriteManager
            .registerFavoriteState(id: model.id)
            .bind(to: isFavoriteRelay)
            .disposed(by: disposeBag)
    }
    
    private func fetchPeople() {
        let fetchAction = provider.fetchPerson(url:)
        let personIDs = model.people.compactMap { URL(string: $0)?.lastPathComponent }
        
        Observable.combineLatest(
            personIDs.enumerated().map {
                fetchAction($0.element).asObservable()
            })
        .do(
            onError: { [weak self] error in
                self?.errorRelay.accept(error)
                self?.isLoadingRelay.accept(false)
            },
            onCompleted: { [weak self] in
                self?.isLoadingRelay.accept(false)
            }, onSubscribe: { [weak self] in
                self?.isLoadingRelay.accept(true)
            }
        )
        .asDriver(onErrorJustReturn: [])
        .drive(peopleRelay)
        .disposed(by: disposeBag)
    }
}
