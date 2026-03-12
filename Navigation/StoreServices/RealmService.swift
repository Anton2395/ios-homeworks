//
//  RealmService.swift
//  Navigation
//
//  Created by Toha Shilin on 11.03.26.
//
import RealmSwift

final class RealmService {
    
    static let shared = RealmService()
    
    private let realm = try! Realm()
    
    func savePost(_ post: Post) {
        guard let id = post.id else { return }
        
        let object = SavedPostRealm()
        object.id = id
        object.author = post.author
        object.postDescription = post.description
        object.imageURL = post.imageURL
        object.likes = post.likes
        object.views = post.views
        object.createdAt = post.createdAt
        
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func deletePost(id: String) {
        if let object = realm.object(ofType: SavedPostRealm.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    
    func getPosts() -> Results<SavedPostRealm> {
        realm.objects(SavedPostRealm.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    func isSaved(id: String) -> Bool {
        realm.object(ofType: SavedPostRealm.self, forPrimaryKey: id) != nil
    }
}
