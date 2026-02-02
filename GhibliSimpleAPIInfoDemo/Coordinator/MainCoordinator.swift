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
    let settingsManager: SettingsManagerProtocol
    
    lazy var provider = FilmsProvider(apiManager: apiManager,
                                      favoriteManager: favoriteManager)
    let disposeBag = DisposeBag()
    
    init(router: Router, apiManager: APIManager, favoriteManager: FavoriteManager, settingsManager: SettingsManagerProtocol) {
        self.apiManager = apiManager
        self.favoriteManager = favoriteManager
        self.settingsManager = settingsManager
        self.router = router
    }
    
    override func start() {
        let filmListTab = createFilmListPageTab()
        let favorityTab = createFavoriteListPageTab()
        let settingsTab = createSettinsPageTab()
        let tabBarVC = BaseTabBarViewController(tabs: [filmListTab, favorityTab, settingsTab])
        
        router.push(tabBarVC)
    }
    
    func showDetailFilmPage(model: Film) {
        let provider = FilmDetailProvider(favoriteManager: favoriteManager, apiManager: apiManager)
        let vm = FilmDetailViewModel(provider: provider, model: model)
        let detailVC = FilmDetailViewController(vm: vm)
        
        vm.eventOutput.error
            .observe(on: MainScheduler())
            .subscribe(onNext: showErrorToast(error:))
            .disposed(by: disposeBag)
        
        settingsManager.theme
            .subscribe(detailVC.rx.overrideUserInterfaceStyle)
            .disposed(by: disposeBag)
        
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
        
        settingsManager.theme
            .subscribe(vc.rx.overrideUserInterfaceStyle)
            .disposed(by: disposeBag)
        
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
        
        settingsManager.theme
            .subscribe(vc.rx.overrideUserInterfaceStyle)
            .disposed(by: disposeBag)
        
        return UITab(title: "Favorites",
                     image: UIImage(systemName: "heart.fill"),
                     identifier: "Favorites",
                     viewControllerProvider: { _ in vc })
    }
    
    func createSettinsPageTab() -> UITab {
        let vm = SettingsViewModel(provider: settingsManager)
        let vc = SettingsViewController(viewModel: vm)
        
        vc.title = "Settings"
        settingsManager.theme
            .subscribe(vc.rx.overrideUserInterfaceStyle)
            .disposed(by: disposeBag)
        
        return UITab(title: "Settings",
                     image: UIImage(systemName: "gear"),
                     identifier: "Settings",
                     viewControllerProvider: { _ in vc })
    }
}
// MARK: Error Process
private extension MainCoordinator {
    func showErrorToast(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        router.present(alert)
    }
}
