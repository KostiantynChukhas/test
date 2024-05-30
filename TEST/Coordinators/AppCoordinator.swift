
//
//  Created by Konstantin Chukhas on 19.10.2021.
//

import Foundation
import UIKit

class AppCoordinator {
    private var window: UIWindow
    private let serviceHolder = ServiceHolder.shared
    private var coordinator: MainCoordinator?
    private var spalshCoordinator: SplashCoordinator?
    
    private lazy var root: UINavigationController = {
        let root = UINavigationController()
        root.setNavigationBarHidden(true, animated: false)
        return root
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = root
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        startInitialServices()
        startSplash()
    }
    
    private func startSplash() {
        spalshCoordinator = SplashCoordinator(navigationController: root)
        spalshCoordinator?.transitions = self
        spalshCoordinator?.route(to: .`self`)
    }
    
    private func startMain() {
        coordinator = MainCoordinator(navigationController: root)
        coordinator?.route(to: .`self`)
    }
}

// MARK: - MainCoordinatorTransitions -

extension AppCoordinator: SplashCoordinatorTransitions {
    func splashIsShown() {
        startMain()
    }
    
}

//MARK: - Services routine -
extension AppCoordinator {
    
    private func startInitialServices() {
        ProjectAPILocator.populate(instance: ProjectAPI())
        
        let booksService = MainService()
        serviceHolder.add(MainService.self, for: booksService)
        
    }
}
