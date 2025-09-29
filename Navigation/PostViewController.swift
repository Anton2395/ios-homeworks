//
//  PostViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: PostTemp = PostTemp(title:"")
    
    var onPostsInfo: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        title = post.title
        
        let infoButton = UIBarButtonItem(
            image: UIImage(systemName: "info.circle"),
            style: .plain,
            target: self,
            action: #selector(infoButtonTapped)
        )
        navigationItem.rightBarButtonItem = infoButton
    }
    
    
    @objc private func infoButtonTapped() {
        onPostsInfo?()
    }

}

struct PostTemp {
    var title: String
}
