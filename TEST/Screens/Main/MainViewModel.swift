

import Foundation

protocol MainViewModelType {
    var items: [TestItemModel] { get }
    var onReload: (EmptyClosureType) { get set }
    func route(to route: MainCoordinator.Route)
}

class MainViewModel: MainViewModelType {
    private var coordinator: MainCoordinator
    private var mainService: MainServiceType
    
    var items: [TestItemModel] = []
    var onReload: (EmptyClosureType) = {  }
    
    init(_ coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.mainService = ServiceHolder.shared.get(by: MainService.self)
        getItems()
    }
    
    private func getItems() {
        mainService.getItems { [weak self] result in
            switch result {
            case .success(let response):
                self?.items = response
                self?.onReload()
            case .failure:
                self?.getItems()
            }
        }
    }
    
    func route(to route: MainCoordinator.Route) {
        coordinator.route(to: route)
    }
    
    
    deinit {
        printDeinit(self)
    }
}
