//
//  FeedViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class FeedViewController: UITableViewController {
    private let viewModel = FeedViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        viewModel.loadPosts()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.loadPosts()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell_ReuseID")
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
        
        cell.onLikePost = { [weak self] post in
            self?.viewModel.likePost(postId: post.id)
        }
        cell.unlikePost = { [weak self] post in
            self?.viewModel.unlikePost(postId: post.id)
        }
        
        cell.onBookmark = { post in
            RealmService.shared.savePost(post)
        }
        cell.unBookmark = { post in
            guard let id = post.id else { return }
            RealmService.shared.deletePost(id: id)
        }
        
        let post = viewModel.posts[indexPath.row]
        cell.update(
            post,
            isLiked: viewModel.isPostLiked(post),
            isBookmark: RealmService.shared.isSaved(id: post.id ?? "")
        )
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.row]
        viewModel.setViewPost(postId: post.id)
    }
}
