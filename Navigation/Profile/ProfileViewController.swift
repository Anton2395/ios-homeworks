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
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()
    
    
    private lazy var newAdditionalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Additional button", for: .normal)
        button.backgroundColor = .systemMint
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .lightGray
        view.addSubview(profileHeaderView)
        view.addSubview(newAdditionalButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            profileHeaderView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            profileHeaderView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            profileHeaderView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            
            newAdditionalButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0),
            newAdditionalButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            newAdditionalButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            newAdditionalButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        
//        profileHeaderView.frame = view.frame
//    }
}
