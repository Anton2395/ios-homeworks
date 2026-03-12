//
//  SavedPostTableViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 2.12.25.
//

import UIKit
import RealmSwift


class SavedPostTableViewController: UITableViewController {
    var viewModel: SavedPostViewModel
    
    var notificationToken: NotificationToken?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.reloadData()
    }
    
    init(viewModel: SavedPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell_ReuseID")
        notificationToken = viewModel.posts.observe { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostTableViewCell_ReuseID",
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        let post = viewModel.posts[indexPath.row]

        cell.update(Post(
            id: post.id,
            userId: "",
            author: post.author,
            description: post.postDescription,
            imageURL: post.imageURL,
            likes: post.likes,
            views: post.views,
            createdAt: post.createdAt
        ), isSavedView: true)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deletePost(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
        }    
    }
}
