//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Data
    fileprivate let data = Post.make()
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private enum CellReuseID: String {
        case photo = "PhotoTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setSubview()
        setConstraints()
        
        tuneTableView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor(_colorLiteralRed: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
    }
    
    func setSubview() {
        view.addSubview(tableView)
    }
    
    func setConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
        ])
    }
    
    func tuneTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300.0
        
        let headerView = ProfileHeaderView()
        tableView.setAndlayout(headerView: headerView)
        tableView.tableFooterView = UIView()
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: CellReuseID.photo.rawValue)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.photo.rawValue,
                for: indexPath
            ) as? PhotoTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.custom.rawValue,
                for: indexPath
            ) as? PostTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            
            cell.update(data[indexPath.row])
            
            return cell
        default:
            fatalError("unexpected section")
        }
    }
}

extension ProfileViewController: UITableViewDelegate {}
