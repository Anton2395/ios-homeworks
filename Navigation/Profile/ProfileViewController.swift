//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var profileHeaderView: ProfileHeaderView = {
        let profileView = ProfileHeaderView()
        
        return profileView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .lightGray
        view.addSubview(profileHeaderView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileHeaderView.frame = view.frame
    }
}
