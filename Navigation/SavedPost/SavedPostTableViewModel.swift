import RealmSwift

final class SavedPostViewModel {
    
    private let service = RealmService.shared
    
    var posts: Results<SavedPostRealm> {
        service.getPosts()
    }
    
    func deletePost(at index: Int) {
        let post = posts[index]
        service.deletePost(id: post.id)
    }
}
