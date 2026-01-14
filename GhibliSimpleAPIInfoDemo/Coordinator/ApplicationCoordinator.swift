//
//  ApplicationCoordinator.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import Foundation

class ApplicationCoordinator: BaseCoordinator {
    
    lazy var apiManager: APIManager = createAPIManager()
    let dataStorage: GBLDataStorage = .init()
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        runMainFlow()
    }
    
    private func runMainFlow() {
        let mainFlow = MainCoordinator(router: router,
                                       apiManager: apiManager,
                                       storage: dataStorage)
        addDependency(mainFlow)
        mainFlow.start()
    }
}

private extension ApplicationCoordinator {
    func createAPIManager() -> APIManager {
        let baseInfo = BaseInfo(uuid: UUID().uuidString, token: "")
        let service = GBLServer(baseInfo: baseInfo)
        return APIManager(server: service)
    }
}
