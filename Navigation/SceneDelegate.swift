//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let tabBarController = UITabBarController()
        
        let feedViewController = FeedViewController()
        let loginViewController = LogInViewController()
        
        let feedNavigationControlle = UINavigationController(rootViewController: feedViewController)
        let profileNavigationController = UINavigationController(rootViewController: loginViewController)
        
        feedNavigationControlle.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBarController.viewControllers = [feedNavigationControlle, profileNavigationController]
        tabBarController.selectedIndex = 0
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

