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
    let storage: GBLDataStorageProtocol
    
    init(router: Router, apiManager: APIManager, storage: GBLDataStorageProtocol) {
        self.apiManager = apiManager
        self.storage = storage
        self.router = router
    }
    
    override func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        router.push(vc)
    }
}
