//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Toha Shilin on 27.09.25.
//
import UIKit

class FeedCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feedViewController = FeedViewController()
        feedViewController.onPost = {[weak self] post in
            self?.showPost(for: post)
        }
        navigationController.viewControllers = [feedViewController]
    }
    
    func showPost(for post: PostTemp) {
        let postViewController = PostViewController()
        postViewController.post = post
        postViewController.onPostsInfo = {[weak self] in
            self?.showPostsInfo()
        }
        navigationController.pushViewController(postViewController, animated: true)
    }
    
    func showPostsInfo() {
        let infoVC = InfoViewController()
        infoVC.modalTransitionStyle = .flipHorizontal
        navigationController.present(infoVC, animated: true)
    }
}
