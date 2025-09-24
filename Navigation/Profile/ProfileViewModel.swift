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
}
