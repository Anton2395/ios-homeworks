//
//  ImgBBService.swift
//  Navigation
//
//  Created by Toha Shilin on 16.02.26.
//

import UIKit

final class ImgBBService {
    static private let apiKey = "d53dc7223da4a21df461103fea4952d9"
    static private let endpoint = "https://api.imgbb.com/1/upload"
    
    static func upload(image: UIImage, compressionQuality: CGFloat = 0.8) async throws -> ImgBBUploadResult {
        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
            throw NSError(domain: "ImgBBService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Cannot convert UIImage to Data"])
        }
        
        let boundary = UUID().uuidString
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else {
            throw NSError(domain: "ImgBBService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // файл
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            let str = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw NSError(domain: "ImgBBService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: str])
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataDict = json["data"] as? [String: Any],
           let url = dataDict["url"] as? String,
           let deleteUrl = dataDict["delete_url"] as? String
        {
            
            return ImgBBUploadResult(url: url, deleteURL: deleteUrl)
        } else {
            throw NSError(domain: "ImgBBService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Cannot parse ImgBB response"])
        }
    }
    
    static func upload(image: UIImage, completion: @escaping (Result<ImgBBUploadResult, Error>) -> Void) {
        Task {
            do {
                let url = try await upload(image: image)
                completion(.success(url))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func deleteImage(deleteURL: String) async throws {
        guard let url = URL(string: deleteURL) else {
            throw NSError(domain: "ImgBBService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid delete URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NSError(domain: "ImgBBService", code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "Failed to delete image"])
        }
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) { self.append(data) }
    }
}

struct ImgBBUploadResult {
    let url: String
    let deleteURL: String
}
