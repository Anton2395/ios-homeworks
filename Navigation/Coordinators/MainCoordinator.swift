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
    private enum LocalizedKeys: String {
        case feedNavTitle = "feed-nav-bar-title"
        case profileNavTitle = "profile-nav-bar-title"
        case savedNavTitle = "saved-nav-bar-title"
        case mapNavTitle = "map-nav-bar-title"
    }
    
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
        let vm = SavedPostViewModel()
        let savedPostNav = UINavigationController(rootViewController: SavedPostTableViewController(viewModel: vm))
        
        feedCoordinator = FeedCoordinator(navigationController: feedNav)
        loginCoordinaor = LogInCoordinator(navigationController: loginNav)
        
        
        feedCoordinator?.start()
        loginCoordinaor?.start()
        
    
        feedNav.tabBarItem =  UITabBarItem(
            title: ~LocalizedKeys.feedNavTitle.rawValue,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        loginNav.tabBarItem = UITabBarItem(
            title: ~LocalizedKeys.profileNavTitle.rawValue,
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        savedPostNav.tabBarItem = UITabBarItem(
            title: ~LocalizedKeys.savedNavTitle.rawValue,
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        
        tabBarController.viewControllers = [feedNav, loginNav, savedPostNav]
        tabBarController.selectedIndex = 0
        navigationController.viewControllers = [tabBarController]
    }
}
