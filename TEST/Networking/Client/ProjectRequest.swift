import Foundation

enum ProjectPath {
    case unknown
    case getItems
    
    var string: String {
        switch self {
        case .unknown: return "unknown"
        case .getItems: return "data/test.json"
        }
    }
}

protocol ProjectRequest: HTTPRequest {
    var ProjectPath: ProjectPath { get }
}

extension ProjectRequest {
    var path: String { return ProjectPath.string }
    var acceptType: AcceptType? {
        return .json
    }
}

extension ProjectRequest {
    var baseURL: URL { return Defines.baseUrl }
}

extension ProjectRequest where Response: DecodableResponse {
    func response(data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        do {
            let response = try Response.decode(data: data, urlResponse: urlResponse)
            print("ProjectRequest response \(response)")
            return response
        } catch {
            print("ProjectRequest response error \(error.localizedDescription)") // here.....
            throw error
        }
        
        //return try Response.decode(data: data, urlResponse: urlResponse)
    }
}

protocol DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Self
}

extension DecodableResponse where Self: Decodable {
    static func decode(data: Data, urlResponse _: URLResponse) throws -> Self {
        do {
            let response = try CustomDecoder().decode(Self.self, from: data)
            print("DecodableResponse decode response \(response)")
            return response
        } catch {
            print("DecodableResponse response error \(error.localizedDescription)") // here.....
            throw error
        }
        
        //return try CustomDecoder().decode(Self.self, from: data)
    }
}

extension ProjectRequest where Failure: DecodableFailure {
    func failure(data: Data, urlResponse: HTTPURLResponse) throws -> Failure {
        return try Failure.decode(data: data, urlResponse: urlResponse)
    }
}

protocol DecodableFailure {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Self
}

extension DecodableFailure where Self: Decodable {
    static func decode(data: Data, urlResponse _: URLResponse) throws -> Self {
        return try CustomDecoder().decode(Self.self, from: data)
    }
}

extension Array: DecodableResponse where Element: Decodable {
    static func decode(data: Data, urlResponse _: URLResponse) throws -> [Element] {
        return try CustomDecoder().decode([Element].self, from: data)
    }
}

extension Result: DecodableResponse where Success: DecodableResponse, Failure: DecodableResponse {
    static func decode(data: Data, urlResponse: URLResponse) throws -> Result<Success, Failure> {
        let successParsingError: Error
        
        do {
            let success = try Success.decode(data: data, urlResponse: urlResponse)
            return .success(success)
        } catch {
            successParsingError = error
        }
        
        do {
            let failure = try Failure.decode(data: data, urlResponse: urlResponse)
            return .failure(failure)
        } catch {
            throw successParsingError
        }
    }
}
