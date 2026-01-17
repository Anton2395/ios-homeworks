//
//  SavedPostTableViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 3.12.25.
//
import StorageService
import CoreData

class SavedPostViewModel {
    private let persistentContainer = CoreDataManager.shared.persistentContainer
    var posts: [Post] = []
    var postChangesBlock: (()->Void)?
    
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let request = SavedPost.fetchRequest()
        persistentContainer.performBackgroundTask { [weak self] backContext in
            let result = (try? backContext.fetch(request)) ?? []
            let mapped = result.map {
                Post(author: $0.author ?? "", description: $0.pDescription ?? "", image: $0.image ?? "", likes: 0, views: 0)
            }
            DispatchQueue.main.async {
                self?.posts = mapped
                self?.postChangesBlock?()
            }
        }
    }
    
    func fetchAuthorPosts(of author: String) {
        let request = SavedPost.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", author)
        persistentContainer.performBackgroundTask { [weak self] backContext in
            let result = (try? backContext.fetch(request)) ?? []
            let mapped = result.map {
                Post(author: $0.author ?? "", description: $0.pDescription ?? "", image: $0.image ?? "", likes: 0, views: 0)
            }
            DispatchQueue.main.async {
                self?.posts = mapped
                self?.postChangesBlock?()
            }
        }
    }
    
    func deletePost(_ object: SavedPost) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(object)
        try? context.save()
    }
    
    
}
