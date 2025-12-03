//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 24.09.25.
//
import Foundation
import StorageService

final class ProfileViewModel {
    private(set) var user: User
    private(set) var posts: [Post] = []
    
    var onDataUpdated: (() -> Void)?
    
    var onShowAlert: ((String, String) -> Void)?
    
    init(user: User) {
        self.user = user
        loadPosts()
    }
    
    func loadPosts() {
        posts = Post.make()
        onDataUpdated?()
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
    
    func updatePosts() {
        posts = generateFakeUpdates(for: posts)
        onDataUpdated?()
    }
    
    
    private func generateFakeUpdates(for posts: [Post]) -> [Post] {
        return posts.map {
            Post(
                author: $0.author,
                description: $0.description,
                image: $0.image,
                likes: Int.random(in: 0...20),
                views: Int.random(in: 0...100)
            )
        }
    }
    
    func addPost(_ post: Post) {
        let request = SavedPost.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND pDescription == %@",
            post.author,
            post.description
        )
        CoreDataManager.shared.persistentContainer.performBackgroundTask { [weak self] backContext in
            let existing = (try? backContext.fetch(request)) ?? []
            guard existing.isEmpty else {
                DispatchQueue.main.async {
                    self?.onShowAlert?("Error", "⚠️ Post already exists, skip saving")
                }
                return
            }
            let savedPost = SavedPost(context: backContext)
            savedPost.author = post.author
            savedPost.pDescription = post.description
            savedPost.image = post.image
            do {
                try backContext.save()
                DispatchQueue.main.async {
                    self?.onShowAlert?("Done", "Saved!")
                }
            } catch {
                DispatchQueue.main.async {
                    self?.onShowAlert?("Error", "❌ Duplicate detected or saving error: \(error)")
                }
            }
        }
    }
}
