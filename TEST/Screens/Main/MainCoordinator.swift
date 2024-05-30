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
    
    private weak var navigationController: UINavigationController?
    private var controller: MainViewController? = MainViewController()
    
    private var viewModel: MainViewModelType? {
        return controller?.viewModel
    }
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        controller?.viewModel = MainViewModel(self)
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
        if let controller = controller {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
