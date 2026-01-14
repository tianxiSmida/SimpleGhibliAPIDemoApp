//
//  BaseCoordinator.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import UIKit

class BaseCoordinator: CoordinatorProtocol {
    
    var childCoordinator: [CoordinatorProtocol] = []
    
    func start() {}
    
    func addDependency(_ coordinator: CoordinatorProtocol) {
        if self.childCoordinator.contains(where: { $0 === coordinator }) {
            return
        }
        self.childCoordinator.append(coordinator)
    }
    
    func removeDependency(_ coordinator: CoordinatorProtocol) {
        childCoordinator = childCoordinator.filter { $0 !== coordinator }
    }
}
