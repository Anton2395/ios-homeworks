//
//  PostDTO.swift
//  Navigation
//
//  Created by Toha Shilin on 15.02.26.
//
import FirebaseFirestore
import UIKit
import RealmSwift

public struct Post: Codable {
    @DocumentID public var id: String?
    public var userId: String
    public let author: String
    public let description: String
    public let imageURL: String
    public var likes: Int
    public var views: Int
    public let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case author
        case description
        case imageURL
        case likes
        case views
        case createdAt
    }
}

class SavedPostRealm: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var author: String
    @Persisted var postDescription: String
    @Persisted var imageURL: String
    @Persisted var likes: Int
    @Persisted var views: Int
    @Persisted var createdAt: Date
}
