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

        let loginService = loginFactory.makeLoginInspector()
        loginViewController.viewModel = LoginViewModel(loginService: loginService)
        
        
        loginViewController.onLoginSuccess = { [weak self] user in
            self?.showProfile(for: user)
        }
        loginViewController.onSignUP = { [weak self] in
            guard let self = self else {
                return
            }
            self.showSignUp()
        }
        
        navigationController.viewControllers = [loginViewController]
    }
    
    func showSignUp() {
        let signUpVC = RegistrationViewController()
        signUpVC.hidesBottomBarWhenPushed = true
        signUpVC.onLogin = { [weak self] in
            guard let self = self else {
                return
            }
            self.backToLogin()
        }
        navigationController.pushViewController(signUpVC, animated: true)
    }
    
    func backToLogin() {
        navigationController.popViewController(animated: true)
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
