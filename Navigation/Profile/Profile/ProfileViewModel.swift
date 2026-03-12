//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 24.09.25.
//
import Foundation
import UIKit

final class ProfileViewModel {
    private(set) var user: User
    private(set) var posts: [Post] = []
    private(set) var myLikes: Set<String> = []
    private(set) var galleryImages: [GalleryImage] = []
    
    var updateAvatar: ((ImgBBUploadResult) -> Void)?
    var onDataUpdated: (() -> Void)?
    
    
    init(user: User) {
        self.user = user
    }
    
    func loadPosts() {
        FirebaseService.loadPosts(completion: { [weak self] posts in
            guard let self = self else { return }

            self.posts = posts
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }, isOwned: true)
        
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
    
    func loadNewStatus(_ newStatus: String) {
        Task {
            do {
                try await FirebaseService.updateStatus(newStatus)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return posts.count
        default: return 0
        }
    }
    
    func post(at indexPath: IndexPath) -> Post? {
        guard indexPath.section == 1 else { return nil }
        return posts[indexPath.row]
    }
    
    
    func addPost(_ description: String, img: UIImage) {
        Task {
            do {
                
                let url = try await ImgBBService.upload(image: img)

                let post = Post(
                    userId: "",
                    author: user.fullName,
                    description: description,
                    imageURL: url.url,
                    likes: 0,
                    views: 0,
                    createdAt: Date()
                )

                try FirebaseService.savePost(post)

                await MainActor.run {
                    print("Done", "Post saved!")
                    self.loadPosts() // обновляем список после сохранения
                }

            } catch {
                print("Error", error.localizedDescription)
            }
        }
    }
    
    func loadGalleryPreview() {
        FirebaseService.loadImages(4) { [weak self] images in
            self?.galleryImages = images ?? []
            self?.onDataUpdated?()
        }
    }
    
    func setNewProfileAvatar(url: ImgBBUploadResult) {
        FirebaseService.updateAvatar(url)
        user.image = url.url
        updateAvatar?(url)
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
