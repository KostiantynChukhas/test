
import Foundation

class ProjectAPI {
    
    static var apiPrefix: String {
        return "https://496.ams3.cdn.digitaloceanspaces.com/data"
    }
    
    static func request(part: String) -> String {
        print("\(apiPrefix)\(part)")
        return "\(apiPrefix)\(part)"
    }
    
    typealias Completion<Request: ProjectRequest> = (Swift.Result<Request.Response, Error>) -> Void
    
    let refreshQueue = DispatchQueue(label: "com.org.com.refresh_queue", attributes: .concurrent)
    private let client: HTTPClient
    private var _isTokenRefreshing = false
    private var isTokenRefreshing: Bool {
        get { return refreshQueue.sync { _isTokenRefreshing } }
        set { refreshQueue.async(flags: .barrier) { self._isTokenRefreshing = newValue } }
    }
    
    private var _savedRequests: [DispatchWorkItem] = []
    private var savedRequests: [DispatchWorkItem] {
        get { return refreshQueue.sync { _savedRequests } }
        set { refreshQueue.async(flags: .barrier) { self._savedRequests = newValue } }
    }
    
    init(session: URLHTTPSession = URLSession.shared) {
        self.client = .init(session: session)
    }
    
    func send<Request: ProjectRequest>(_ request: Request, completion: @escaping Completion<Request>) {
        guard isTokenRefreshing == false else {
            saveRequest { [weak self] in
                self?.send(request, completion: completion)
            }
            return
        }
        client.send(request, requestBuilder: { try request.buildURLRequest() }, compeltion: { [weak self] result in
                self?.refreshTokenIfNeeded(request: request, result: result, completion: completion)
            })
    }
    
    func refreshTokenIfNeeded<Request: ProjectRequest>(request: Request, result: Swift.Result<(Data, HTTPURLResponse), HTTPRequestError>, completion: @escaping Completion<Request>) {
        completion(transformResult(request: request, result: result))
    }
    
    private func transformResult<Request: ProjectRequest>(
        request: Request,
        result: Swift.Result<(Data, HTTPURLResponse), HTTPRequestError>
    ) -> Swift.Result<Request.Response, Error> {
        switch result {
        case let .success((data, response)):
            switch response.statusCode {
            case 200...399:
                do {
                    return .success(try request.response(data: data, urlResponse: response))
                } catch {
                    return .failure(ProjectAPIError.unknown)
                }
            case 400...:
                do {
                    return .failure(try request.failure(data: data, urlResponse: response))
                } catch {
                    return .failure(ProjectAPIError.unknown)
                }
            default:
                return .failure(ProjectAPIError.unknown)
            }
        case .failure(let error):
            switch error {
            case .requestError(let error):
                print(error.localizedDescription)
                return .failure(ProjectAPIError.unknown)
            case
                .invalidBaseURL,
                .responseError,
                .nonHTTPResponse:
                return .failure(ProjectAPIError.unknown)
            }
        }
    }
    
    private func saveRequest(_ perform: @escaping () -> Void) {
        savedRequests.append(DispatchWorkItem { perform() })
    }
    
    private func executeAllSavedRequests() {
        savedRequests.forEach { $0.perform() }
        savedRequests.removeAll()
    }
    
    deinit {
        printDeinit(self)
    }
    
}
