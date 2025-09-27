//
//  LogInCoordinator.swift
//  Navigation
//
//  Created by Toha Shilin on 27.09.25.
//

import UIKit

class LogInCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let loginFactory = MyLoginFactory()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LogInViewController()
        loginViewController.loginDelegate = loginFactory.makeLoginInspector()
        loginViewController.onLoginSuccess = { [weak self] user in
            self?.showProfile(for: user)
        }
        navigationController.viewControllers = [loginViewController]
    }
    
    func showProfile(for user: User) {
        let profileViewController = ProfileViewController(user: user)
        profileViewController.showPhotosCollection = { [weak self] in
            self?.showPhotos()
        }
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    func showPhotos() {
        let photoView = PhotosViewController()
        navigationController.pushViewController(photoView, animated: true)
    }
}
