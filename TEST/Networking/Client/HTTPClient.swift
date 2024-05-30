
//  Created by Konstantin Chukhas on 19.10.2021.

import Foundation

protocol URLHTTPTask {
    func resume()
    func cancel()
}

protocol URLHTTPSession {
    @discardableResult
    func send(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLHTTPTask
}

extension URLSession: URLHTTPSession {
    @discardableResult
    func send(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLHTTPTask {
        let task = self.dataTask(with: request, completionHandler: completion)
        return task
    }
}

extension URLSessionDataTask: URLHTTPTask { }

class HTTPClient {
    private let session: URLHTTPSession
    
    init(session: URLHTTPSession) {
        self.session = session
    }
    
    func send<Request: HTTPRequest>(_ request: Request, requestBuilder: Request.URLRequestBuilder, compeltion: @escaping (Result<(Data, HTTPURLResponse), HTTPRequestError>) -> Void) {
        var urlRequest: URLRequest
        do {
            urlRequest = try requestBuilder()
        } catch let error as HTTPRequestError {
            compeltion(.failure(error))
            return
        } catch {
            assertionFailure("Unexpected error from building an URLRequest from HTTPRequest")
            compeltion(.failure(HTTPRequestError.requestError(error)))
            return
        }
        
        urlRequest.timeoutInterval = 10
        
        let task = session.send(request: urlRequest) { data, urlResponse, error in
            let result: Result<(Data, HTTPURLResponse), HTTPRequestError>
            switch (data, urlResponse, error) {
            case (_, _, let error?):
                result = .failure(HTTPRequestError.requestError(error))
            case let(data?, urlResponse as HTTPURLResponse, _):
//                guard 200 ..< 300 ~= urlResponse.statusCode else {
//                    print("Status code was \(urlResponse.statusCode), but expected 2xx")
//                    result = .failure(HTTPRequestError.nonHTTPResponse(urlResponse))
//                    compeltion(result)
//                    return
//                }
                result = .success((data, urlResponse))
            default:
                result = .failure(HTTPRequestError.nonHTTPResponse(urlResponse))
            }
            compeltion(result)
        }
        task.resume()
    }
    
    deinit {
        printDeinit(self)
    }
}

