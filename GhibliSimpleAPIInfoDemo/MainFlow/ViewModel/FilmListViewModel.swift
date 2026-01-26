//
//  FilmListViewModel.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/16.
//

import RxSwift
import RxCocoa

class FilmListViewModel {
    
    struct Input {
        /// 點擊電影
        let didSelected: Observable<FilmCellViewModel>
    }
    
    struct Output {
        /// 電影列表資訊
        let films: Driver<[FilmCellViewModel]>
    }
    
    struct EventOutput {
        let didSelected: Observable<Film>
    }
    var event: EventOutput {
        .init(didSelected: didSelectedSubject.map { $0.model })
    }
    
    private let provider: FilmsProviderProtocol
    private let didSelectedSubject = PublishSubject<FilmCellViewModel>()
    private var disposeBag = DisposeBag()
    
    init(provider: FilmsProviderProtocol) {
        self.provider = provider
    }
    
    func transform(input: Input) -> Output {
        disposeBag = .init()
        
        input.didSelected
            .subscribe(didSelectedSubject)
            .disposed(by: disposeBag)
        
        let favoriteManager = provider.favoriteManager
        let films = provider.fetchFilms()
            .map {
                $0.map {
                    FilmCellViewModel(favoriteManager: favoriteManager, model: $0)
                }
            }.asDriver(onErrorJustReturn: [])
        return .init(films: films)
    }
}
