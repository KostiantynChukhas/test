
import Foundation
import UIKit
import CommonCrypto
import Dispatch

private let kConcurentRequestsCount: Int = 5

class ImageCacheItem {
    let url: URL
    var bInProgress: Bool = false
    
    init(url: URL) {
        self.url = url
    }
}

protocol ImageCachingServiceType: Service {
    func load(from imageURL: URL?, completion: ((UIImage?) -> Void)?)
    func cleanCache()
}

class ImageCachingService: ImageCachingServiceType {
    static let shared: ImageCachingServiceType = ImageCachingService()
    private var pathForFolder: String?
    
    init() {
        createPathForFolder()

        //debug only
        //cleanCache()
    }
    
    func load(from imageURL: URL?, completion: ((UIImage?) -> Void)? = nil) {
        guard let url = imageURL else {
            completion?(nil)
            return
        }

        //check for cache
        if let image = loadImageFromCache(url: url.absoluteString) {
            completion?(image)
            return
        }

        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .userInitiated).async {
            let session = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, response, _ in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    self?.saveImageToCache(url: url.absoluteString, imageData: data)
                    completion?(image)
                } else {
                    completion?(nil)
                }
            })
            session.resume()
        }
    }
    
    private func saveImageToCache(url: String, imageData: Data) {
        guard let filePath = getPath(urlString: url) else { return }
        let filePathUrl = URL(fileURLWithPath: filePath)
        try? imageData.write(to: filePathUrl)
    }
    
    private func loadImageFromCache(url: String) -> UIImage? {
        guard let filePath = getPath(urlString: url) else { return nil }
        if checkFromImageFromCache(url: url) {
            if let image = UIImage(contentsOfFile: filePath) {
                return image
            }
        }
        return nil
    }
    
    private func checkFromImageFromCache(url: String) -> Bool {
        guard let filePath = getPath(urlString: url) else { return false }
        if FileManager.default.fileExists(atPath: filePath) {
            return true
        }
        return false
    }
}

// MARK: - Disk routine
extension ImageCachingService {
    func cleanCache() {
        guard let folder = pathForFolder else { return }
        let folderURL = URL(fileURLWithPath: folder)
        try? FileManager.default.removeItem(at: folderURL)
        
        createPathForFolder()
    }
    
    private func createPathForFolder() {
        guard let cacheDirPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return }
        let folderPath = cacheDirPath + "/ImageViewCache"
        
        if FileManager.default.fileExists(atPath: folderPath) == false {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                debugPrint(error.localizedDescription)
            }
        }
        pathForFolder = folderPath
    }
    
    private func getPath(urlString: String) -> String? {
        // added url contain runtime query items, cache dont work
        guard let url = URL(string: urlString), let host = url.host else { return nil }
        guard let path = pathForFolder else { return nil }
        let file = MD5(string: host + url.path)
        let fileUrl = path + "/" + file + ".jpg"
        return fileUrl
    }
    
    private func MD5(string: String) -> String {
        let data = string.data(using: .utf8) ?? Data()
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        let md5Hex = hash.map { String(format: "%02x", $0) }.joined()
        return md5Hex
    }
}
