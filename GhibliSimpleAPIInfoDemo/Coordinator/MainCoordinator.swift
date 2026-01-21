//
//  MainCoordinator.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import UIKit
import RxSwift

class MainCoordinator: BaseCoordinator {
    let router: Router
    let apiManager: APIManager
    let favoriteManager: FavoriteManager
    
    lazy var provider = FilmsProvider(apiManager: apiManager,
                                      favoriteManager: favoriteManager)
    let disposeBag = DisposeBag()
    
    init(router: Router, apiManager: APIManager, favoriteManager: FavoriteManager) {
        self.apiManager = apiManager
        self.favoriteManager = favoriteManager
        self.router = router
    }
    
    override func start() {
        let filmListVM = FilmListViewModel(provider: provider.createFilmListProvider())
        let vc = FilmListViewController(vm: filmListVM)
        filmListVM.event.didSelected
            .subscribe(onNext: showDetailFilmPage(vm:))
            .disposed(by: disposeBag)
        router.push(vc)
    }
    
    func showDetailFilmPage(vm: FilmCellViewModel) {
        
    }
}
