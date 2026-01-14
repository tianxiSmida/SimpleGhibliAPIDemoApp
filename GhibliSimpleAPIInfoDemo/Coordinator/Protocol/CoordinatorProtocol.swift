//
//  CoordinatorProtocol.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import Foundation

protocol CoordinatorProtocol: AnyObject {
    var childCoordinator: [CoordinatorProtocol] { get set }
    func start()
}

protocol CoordinatorFinishProtocol {
    associatedtype deliverableType
    var finishFlow: ((deliverableType?) -> Void)? { get set }
}
