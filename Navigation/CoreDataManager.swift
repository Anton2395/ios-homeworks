//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Toha Shilin on 2.12.25.
//
import CoreData
import Foundation
import StorageService

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func fetchPosts() -> [Post] {
        let request = SavedPost.fetchRequest()
        let tempPost = (try? persistentContainer.viewContext.fetch(request)) ?? []
        return tempPost.map { t_post in
            Post(author: t_post.author ?? "", description: t_post.pDescription ?? "", image: t_post.image ?? "", likes: 0, views: 0)
        }
    }
    
    func addPost(_ post: Post) {
        let request = SavedPost.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND pDescription == %@",
            post.author,
            post.description
        )
        let existing = (try? persistentContainer.viewContext.fetch(request)) ?? []
        guard existing.isEmpty else {
            print("⚠️ Post already exists, skip saving")
            return
        }
        
        let savedPost = SavedPost(context: persistentContainer.viewContext)
        savedPost.author = post.author
        savedPost.pDescription = post.description
        savedPost.image = post.image
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("❌ Duplicate detected or saving error: \(error)")
        }
    }
    
    func deletePost(_ post: Post) {
        let request = SavedPost.fetchRequest()
        request.predicate = NSPredicate(
            format: "author == %@ AND pDescription == %@",
            post.author,
            post.description
        )
        let posts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        for old_post in posts {
            persistentContainer.viewContext.delete(old_post)
        }
        try? persistentContainer.viewContext.save()
    }
}
