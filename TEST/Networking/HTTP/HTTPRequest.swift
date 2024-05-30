import Foundation

enum HTTPRequestError: Error {
    case invalidBaseURL(URL)
    case requestError(Error)
    case responseError(Error)
    case nonHTTPResponse(URLResponse?)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ContentType: String {
    case json = "application/json"
    case formData = "multipart/from-data"
}

enum AcceptType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
}

enum HeaderType: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case accepType = "Accept-Type"
    case mockedResponseCode = "x-mock-response-code"
}

struct QueryParameter {
    let key: String
    let value: String
}

protocol HTTPRequest {
    associatedtype Response
    associatedtype Failure: Error

    typealias URLRequestBuilder = () throws -> URLRequest

    var baseURL: URL { get }

    var method: HTTPMethod { get }

    var path: String { get }

    var queryParameters: [QueryParameter] { get }

    var bodyParameters: [String: Any] { get }

    var contentType: ContentType { get }

    var acceptType: AcceptType? { get }

    var headerFields: [String: String] { get }

    func response(data: Data, urlResponse: HTTPURLResponse) throws -> Response
    func failure(data: Data, urlResponse: HTTPURLResponse) throws -> Failure
}

struct HTTPRequestAuth {
    let key: String
    let value: String
}

extension HTTPRequest {
    func failure(data: Data, urlResponse _: HTTPURLResponse) throws -> ProjectAPIError {
        return try JSONDecoder().decode(ProjectAPIError.self, from: data)
    }
}

extension HTTPRequest {
    var parameters: Any? {
        return nil
    }

    var queryParameters: [QueryParameter] {
        return []
    }

    var bodyParameters: [String: Any] {
        return [:]
    }

    var contentType: ContentType {
        return .json
    }

    var acceptType: AcceptType? {
        return nil
    }

    var headerFields: [String: String] {
        return [:]
    }

    func buildURLRequest() throws -> URLRequest {
        let url = path.isEmpty ? baseURL : URL(string: baseURL.absoluteString.appending(path))!

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw HTTPRequestError.invalidBaseURL(baseURL)
        }

        var urlRequest = URLRequest(url: url)

        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { .init(name: $0.key, value: $0.value) }
        }

        if method == .post || method == .put || method == .patch {
            urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }

        if !bodyParameters.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
        }

        urlRequest.url = components.url
        urlRequest.httpMethod = method.rawValue

        if let acceptType = acceptType {
            urlRequest.setValue(acceptType.rawValue, forHTTPHeaderField: "Accept")
        }

        headerFields.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
