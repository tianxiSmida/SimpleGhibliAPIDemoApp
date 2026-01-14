//
//  Router.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/14.
//

import UIKit

class Router: NSObject {
    private weak var rootController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    private var presentedViewControllers: [UIViewController] = []
    private var presentedNavigationControllers: [UINavigationController] = []
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completions = [:]
        super.init()
        self.rootController?.delegate = self
        self.presentedViewControllers.append(rootController)
        self.presentedNavigationControllers.append(rootController)
    }
}

extension Router: UINavigationControllerDelegate {
    func present(_ viewController: UIViewController, animated: Bool = false) {
        guard let lastPresentViewController = lastViewController() else { return }
        lastPresentViewController.present(viewController, animated: animated)
        presentedViewControllers.append(viewController)
        if let newNavigationController = viewController as? UINavigationController {
            presentedNavigationControllers.append(newNavigationController)
        }
    }
    
    func dismiss(_ animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let lastViewController = lastViewController() else { return }
        if lastViewController.presentedViewController == nil {
            presentedViewControllers.removeLast()
            if lastViewController === presentedNavigationControllers.last {
                presentedNavigationControllers.removeLast()
            }
        }
        lastViewController.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let completion = completion {
            completions[viewController] = completion
        }
        presentedNavigationControllers.last?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        if let controller = presentedNavigationControllers.last?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ viewController: UIViewController, hideBar: Bool = false) {
        guard let rootController = rootController else { return }
        var presentedViewControllerCount = 0
        var targetViewController: UIViewController? = rootController
        while targetViewController?.presentedViewController != nil {
            presentedViewControllerCount += 1
            targetViewController = targetViewController?.presentedViewController
        }
        for _ in 0 ..< presentedViewControllerCount {
            rootController.dismiss(animated: false, completion: nil)
        }
        presentedViewControllers = [rootController]
        presentedNavigationControllers = [rootController]
        self.rootController?.setViewControllers([viewController], animated: false)
        self.rootController?.isNavigationBarHidden = hideBar
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = self.completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
    
    func popToViewController(_ viewController: UIViewController) {
        presentedNavigationControllers.last?.popToViewController(viewController, animated: true)
    }
    
    func lastViewController() -> UIViewController? {
        var lastViewController: UIViewController? = presentedViewControllers.last
        while lastViewController != nil,
              lastViewController?.view.window == nil {
            let _ = presentedViewControllers.popLast()
            lastViewController = presentedViewControllers.last
        }
        return lastViewController
    }
}
