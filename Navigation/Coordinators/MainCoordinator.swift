//
//  MainCoordinator.swift
//  Navigation
//
//  Created by Toha Shilin on 27.09.25.
//
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}


class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var tabBarController: UITabBarController
    
    private var feedCoordinator: FeedCoordinator?
    private var loginCoordinaor: LogInCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.isNavigationBarHidden = true
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let feedNav = UINavigationController()
        let loginNav = UINavigationController()
        let savedPostNav = UINavigationController(rootViewController: SavedPostTableViewController())
        
        feedCoordinator = FeedCoordinator(navigationController: feedNav)
        loginCoordinaor = LogInCoordinator(navigationController: loginNav)
        
        
        feedCoordinator?.start()
        loginCoordinaor?.start()
        
    
        feedNav.tabBarItem =  UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        loginNav.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        savedPostNav.tabBarItem = UITabBarItem(
            title: "Saved",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        tabBarController.viewControllers = [feedNav, loginNav, savedPostNav]
        tabBarController.selectedIndex = 0
        navigationController.viewControllers = [tabBarController]
    }
}
