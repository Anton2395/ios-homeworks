//
//  FirebaseService.swift
//  Navigation
//
//  Created by Toha Shilin on 15.02.26.
//
import FirebaseFirestore
import FirebaseAuth

final class FirebaseService {
    
    static func savePost(_ post: Post) throws {
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        var tempPost = post
        tempPost.userId = currentUser.uid
        _ = try db.collection("posts").addDocument(from: tempPost)
    }
    
    static func loadPosts(completion: @escaping ([Post]) -> Void, isOwned: Bool = false) {
        let db = Firestore.firestore()
        
        var query: Query = db.collection("posts")
            .order(by: "createdAt", descending: true)
        
        if isOwned {
            var userId = ""
            if let currentUser = Auth.auth().currentUser {
                userId = currentUser.uid
            }
            query = query.whereField("user_id", isEqualTo: userId)
        }

        query.getDocuments { snapshot, error in
            if let error = error {
                print("Firestore error:", error.localizedDescription)
                completion([])
                return
            }

            guard let documents = snapshot?.documents else {
                completion([])
                return
            }

            let posts = documents.compactMap { doc -> Post? in
                var post = try? doc.data(as: Post.self)
                post?.id = doc.documentID
                return post
            }

            completion(posts)
        }
    }
    
    
    
    static func updateAvatar(_ url: ImgBBUploadResult, completion: ((Error?) -> Void)? = nil) {
        guard let currentUser = Auth.auth().currentUser else {
            completion?(
                NSError(
                    domain: "FirebaseService",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
                )
            )
            return
        }
        
        let db = Firestore.firestore().collection("users_extensions")
        
        // Прямое обращение к документу с ID = UID пользователя
        let userDocRef = db.document(currentUser.uid)
        
        userDocRef.updateData([
            "image_name": url.url,
            "delete_image_url": url.deleteURL
        ]) { error in
            completion?(error)
        }
    }
    
    static func updateStatus(_ newStatus: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(
                domain: "AuthError",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "User is not authenticated"]
            )
        }
        
        let db = Firestore.firestore().collection("users_extensions")
        let userDocRef = db.document(currentUser.uid)
        do {
            try await userDocRef.updateData([
                "status": newStatus,
            ])
            print("✅ Status successfully updated")
        } catch {
            print("❌ Failed to update status:", error.localizedDescription)
            throw error
        }
    }
    
    static func saveImage(url: ImgBBUploadResult) throws -> GalleryImage {
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(
                domain: "AuthError",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "User is not authenticated"]
            )
        }
        let db = Firestore.firestore()
        let docRef = db.collection("images").document()

        var image = GalleryImage(
            id: nil,
            userId: currentUser.uid,
            imageURL: url.url,
            deleteImageURL: url.deleteURL,
            dateLoaded: Date()
        )

        try docRef.setData(from: image)

        // 🔥 ВАЖНО: не создаём новый объект
        image.id = docRef.documentID

        return image
    }
    
    static func deleteImage(_ image: GalleryImage) async throws {
        guard let imageId = image.id else {
            throw NSError(
                domain: "FirestoreError",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Image id is missing"]
            )
        }
        
        let db = Firestore.firestore()
        
        try await db.collection("images").document(imageId).delete()
    }
    
    static func loadImages(_ limit: Int? = nil, completion: @escaping ([GalleryImage]?) -> Void)  {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        let db = Firestore.firestore()
        
        var query: Query = db.collection("images")
            .whereField("user_id", isEqualTo: currentUser.uid)
            .order(by: "date_loaded", descending: true)
        if let limit = limit {
            query = query.limit(to: limit)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("❌ Load images error:", error.localizedDescription)
                completion(nil)
                return
            }
            guard let documents = snapshot?.documents else {
                
                completion([])
                return
            }
            do {
                let images = try documents.compactMap {
                    try $0.data(as: GalleryImage.self)
                }
                completion(images)
            } catch {
                print("❌ Decoding error:", error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    static func setViewPost(postId: String) async throws {
        let db = Firestore.firestore()
        
        let postRef = db.collection("posts").document(postId)
        
        let batch = db.batch()
        
        batch.updateData([
            "views": FieldValue.increment(Int64(1))
        ], forDocument: postRef)
        
        try await batch.commit()
    }
    
    // Likes
    static func likePost(postId: String) async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        
        let postRef = db.collection("posts").document(postId)
        
        let likeRef = db.collection("users_extensions")
            .document(currentUser.uid)
            .collection("likes")
            .document(postId)
        
        let batch = db.batch()
        
        batch.setData([
            "createdAt": Timestamp()
        ], forDocument: likeRef)
        
        batch.updateData([
            "likes": FieldValue.increment(Int64(1))
        ], forDocument: postRef)
        
        try await batch.commit()
    }
    
    static func unlikePost(postId: String) async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        
        let postRef = db.collection("posts").document(postId)
        
        let likeRef = db.collection("users_extensions")
            .document(currentUser.uid)
            .collection("likes")
            .document(postId)
        
        let batch = db.batch()
        
        batch.deleteDocument(likeRef)
        
        batch.updateData([
            "likes": FieldValue.increment(Int64(-1))
        ], forDocument: postRef)
        
        try await batch.commit()
    }
    
    static func loadLikedPosts() async throws -> Set<String> {
        guard let currentUser = Auth.auth().currentUser else { return [] }
        
        let db = Firestore.firestore()
        
        let snapshot = try await db.collection("users_extensions")
            .document(currentUser.uid)
            .collection("likes")
            .getDocuments()
        
        let ids = snapshot.documents.map { $0.documentID }
        
        return Set(ids)
    }
    
    static func toggleLike(post: Post, isLiked: Bool) async throws {
        guard let postId = post.id else { return }
        
        if isLiked {
            try await unlikePost(postId: postId)
        } else {
            try await likePost(postId: postId)
        }
    }
    
}
