
import Foundation

enum ProjectAPILocator {
    static var shared: ProjectAPI {
        guard let instance = instance else { fatalError("API not populated") }
        return instance
    }
    private static var instance: ProjectAPI?
    static func populate(instance: ProjectAPI) {
        self.instance = instance
    }
}

typealias Fetcher<Request: ProjectRequest> = (
    _ request: Request,
    _ completion: @escaping (Result<Request.Response, Error>) -> Void
) -> Void

protocol DataFetcher {
    func send<Request: ProjectRequest>(
        _ request: Request,
        completion: @escaping (Result<Request.Response, Error>) -> Void
    )
}

extension ProjectAPI: DataFetcher {}
