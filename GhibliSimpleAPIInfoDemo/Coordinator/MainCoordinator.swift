//
//  MainCoordinator.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    let router: Router
    let apiManager: APIManager
    let favoriteManager: FavoriteManager
    
    lazy var provider = FilmsProvider(apiManager: apiManager,
                                      favoriteManager: favoriteManager)
    
    init(router: Router, apiManager: APIManager, favoriteManager: FavoriteManager) {
        self.apiManager = apiManager
        self.favoriteManager = favoriteManager
        self.router = router
    }
    
    override func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        router.push(vc)
    }
}
