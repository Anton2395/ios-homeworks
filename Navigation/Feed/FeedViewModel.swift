//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//
import UIKit

final class FeedViewModel {
    private(set) var posts: [Post] = []
    private(set) var myLikes: Set<String> = []
    
    var onDataUpdated: (() -> Void)?
    
    init() {
    }
    
    func loadPosts() {
        FirebaseService.loadPosts(completion: { [weak self] posts in
            guard let self = self else { return }

            self.posts = posts
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }, isOwned: false)
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                self.myLikes = try await FirebaseService.loadLikedPosts()
                await MainActor.run {
                    self.onDataUpdated?()
                }
            } catch {
                print("Failed to load likes:", error)
            }
        }
    }
    
    func isPostLiked(_ post: Post) -> Bool {
        guard let id = post.id else { return false }
        return myLikes.contains(id)
    }
    
    func likePost(postId: String?) {
        guard let postId = postId, Checker.shared.loginStatus() else { return }
        
        myLikes.insert(postId)
        
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].likes += 1
        }
        
        onDataUpdated?()
        
        Task {
            do {
                try await FirebaseService.likePost(postId: postId)
            } catch {
                print("Like error:", error)
            }
        }
    }
    
    func unlikePost(postId: String?) {
        guard let postId = postId, Checker.shared.loginStatus() else { return }
                
        myLikes.remove(postId)
        
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].likes -= 1
        }
        
        onDataUpdated?()
        
        Task {
            do {
                try await FirebaseService.unlikePost(postId: postId)
            } catch {
                print("Unlike error:", error)
            }
        }
    }
    
    func setViewPost(postId: String?) {
        guard let postId = postId else { return }
        
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].views += 1
        }
        
        Task {
            do {
                try await FirebaseService.setViewPost(postId: postId)
            } catch {
                print("Unlike error:", error)
            }
        }
    }
}

