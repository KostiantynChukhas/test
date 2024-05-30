import Foundation

protocol MainServiceType: Service {
    func getItems(completion: @escaping (Result<[TestItemModel], Error>) -> Void)
}

class MainService: MainServiceType {
    
    func getItems(completion: @escaping (Result<[TestItemModel], Error>) -> Void) {
        let request = GetItemsRequest()
        
        ProjectAPILocator.shared.send(request) {
            switch $0 {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    deinit {
        printDeinit(self)
    }
}
