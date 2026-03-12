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
        navigationController.viewControllers = [feedViewController]
    }
    
}
