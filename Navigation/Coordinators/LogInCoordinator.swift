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
        Checker.shared.loadUser { [weak self] user in
            guard let self = self else { return }

            if let user {
                self.showProfile(for: user)
            } else {
                self.showLogin()
            }
        }
        
    }
    
    func showLogin() {
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
    
    func logout() {
        Checker.shared.logout()
        start()
    }
    
    func backToLogin() {
        navigationController.popViewController(animated: true)
    }
    
    func showProfile(for user: User) {
        let viewModel = ProfileViewModel(user: user)
        let profileViewController = ProfileViewController(viewModel: viewModel)
        
        profileViewController.showPhotosCollection = { [weak self] userImage in
            self?.showPhotos(userImage: userImage) { avatarURL in
                viewModel.setNewProfileAvatar(url: avatarURL)
            }
        }
        profileViewController.logoutPressed = { [weak self] in
            self?.logout()
        }
        navigationController.pushViewController(profileViewController, animated: true)
    }
    
    
    func showPhotos(userImage: String, setNewAvatar: @escaping (ImgBBUploadResult) -> Void) {
        let viewModel = PhotosViewModel(userImage: userImage)
        viewModel.setNewAvatar = { avatarURL in
            setNewAvatar(avatarURL)
        }
        let photoView = PhotosViewController(viewModel: viewModel)
        navigationController.pushViewController(photoView, animated: true)
    }
}
