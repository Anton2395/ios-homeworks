//
//  Gallery.swift
//  Navigation
//
//  Created by Toha Shilin on 28.07.25.
//
import FirebaseFirestore


struct GalleryImage: Codable {
    @DocumentID var id: String?
    var userId: String
    var imageURL: String
    var deleteImageURL: String
    var dateLoaded: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case imageURL = "image_url"
        case deleteImageURL = "delete_image_url"
        case dateLoaded = "date_loaded"
    }
}


//struct Gallery {
//    let imageName: String
//}
//
//extension Gallery {
//    static func make(completion: (Result<[Gallery], ApiError>) -> Void)  {
//        completion(.success((1...20).compactMap { Gallery(imageName: "galery\($0)") }))
//    }
//}
