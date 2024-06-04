//
//  MainCoordinator.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import UIKit

protocol MainCoordinatorTransitions: AnyObject {
    func didLoggedIn()
}

class MainCoordinator {
    enum Route {
        case `self`
    }
    
    weak var transitions: MainCoordinatorTransitions?
    
    private let window: UIWindow
    private lazy var root = UINavigationController(rootViewController: controller)
    private var controller: MainViewController = MainViewController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    deinit {
        printDeinit(self)
    }
}

// MARK: - Navigation -

extension MainCoordinator {
    func route(to destination: Route) {
        switch destination {
        case .`self`: start()
        }
    }
    
    private func start() {
        controller.viewModel = MainViewModel(self)

        root.setNavigationBarHidden(false, animated: false)
        root.setViewControllers([controller], animated: false)
        
        window.rootViewController = root
        window.makeKeyAndVisible()
    }
    
}
