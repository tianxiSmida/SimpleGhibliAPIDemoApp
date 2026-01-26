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
        let filmListTab = createFilmListPageTab()
        let favorityTab = createFavoriteListPageTab()
        let tabBarVC = BaseTabBarViewController(tabs: [filmListTab, favorityTab])
        
        router.push(tabBarVC)
    }
    
    func showDetailFilmPage(model: Film) {
        let provider = FilmDetailProvider(favoriteManager: favoriteManager, apiManager: apiManager)
        let vm = FilmDetailViewModel(provider: provider, model: model)
        let detailVC = FilmDetailViewController(vm: vm)
        router.push(detailVC)
    }
}

private extension MainCoordinator {
    func createFilmListPageTab() -> UITab {
        let filmListVM = FilmListViewModel(provider: provider.createFilmListProvider())
        let vc = FilmListViewController(vm: filmListVM)
        
        filmListVM.event.didSelected
            .subscribe(onNext: showDetailFilmPage(model:))
            .disposed(by: disposeBag)
        vc.title = "Ghibli Movies"
        
        return UITab(title: "Movies",
                     image: UIImage(systemName: "movieclapper"),
                     identifier: "Movies",
                     viewControllerProvider: { _ in vc })
    }
    
    func createFavoriteListPageTab() -> UITab {
        let filmListVM = FilmListViewModel(provider: provider.createFavirateFilmListProvider())
        let vc = FilmListViewController(vm: filmListVM)
        
        filmListVM.event.didSelected
            .subscribe(onNext: showDetailFilmPage(model:))
            .disposed(by: disposeBag)
        vc.title = "Favorites"
        
        return UITab(title: "Favorites",
                     image: UIImage(systemName: "heart.fill"),
                     identifier: "Favorites",
                     viewControllerProvider: { _ in vc })
    }
}
