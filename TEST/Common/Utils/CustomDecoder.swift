
import Foundation

class CustomDecoder {
    private let decoder = JSONDecoder()

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }

    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }

    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if type == EmptyResponse.self { // check for empty response
            return EmptyResponse() as! T
        }
        
        do {
            let response = try decoder.decode(type, from: data)
            print("CustomDecoder decode response \(response)")
            return response
        } catch {
            let jsonString = String(data: data, encoding: .utf8)
            print("CustomDecoder response jsonString \(String(describing: jsonString))")
            if let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("CustomDecoder response dict \(jsonDict)")
            }
            
            var errorStr = error.localizedDescription
            if let decError = error as? DecodingError, let debugInfo = decError.localizedDebugInfo {
                errorStr = debugInfo
            }
            
            print("CustomDecoder response error with \(type) \(errorStr)") // here.....
            throw error
        }
        
        // return try decoder.decode(type, from: data)
    }

    init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z"
        formatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
        formatter.locale = Locale.current

        dateDecodingStrategy = .formatted(formatter)
        keyDecodingStrategy = .convertFromSnakeCase
    }
}

struct EmptyResponse: Codable {
}
