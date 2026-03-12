//
//  UserModel.swift
//  Navigation
//
//  Created by Toha Shilin on 8.09.25.
//
import UIKit
import FirebaseFirestore


class User {
    var name: String
    var fullName: String
    var image: String
    var deleteImageURL: String
    var status: String
    
    
    init(name: String, fullName: String, image: String, status: String, deleteImageURL: String) {
        self.name = name
        self.fullName = fullName
        self.image = image
        self.status = status
        self.deleteImageURL = deleteImageURL
    }
    
    init(name: String, userExten: UserExtensions) {
        self.name = name
        self.fullName = userExten.fullName
        self.image = userExten.imageName
        self.status = userExten.status
        self.deleteImageURL = userExten.deleteImageURL
    }
}

struct UserExtensions: Codable {
    @DocumentID var id: String?
    var fullName: String
    var imageName: String
    var deleteImageURL: String
    var status: String
    var userId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case imageName = "image_name"
        case deleteImageURL = "delete_image_url"
        case status
        case userId = "user_id"
    }
}
