//
//  SavedPostTableViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 2.12.25.
//

import UIKit

class SavedPostTableViewController: UITableViewController {
    
    var viewModel: SavedPostViewModel
//    var posts = CoreDataManager.shared.fetchPosts()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        posts = CoreDataManager.shared.fetchPosts()
        viewModel.fetchPosts()
        navigationItem.rightBarButtonItem?.isHidden = true
//        tableView.reloadData()
    }
    
    init(viewModel: SavedPostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.postChangesBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell_ReuseID")
        setupNavigation()
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Фильтр", image: nil, target: self, action: #selector(tapFilter))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(cleanFilter))
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    @objc func tapFilter() {
        let alert = UIAlertController(title: "Filter", message: "Set filter", preferredStyle: .alert)
        
        alert.addTextField() { textField in
            textField.placeholder = "Enter author name"
        }
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { [weak self](_) in

            let author = alert.textFields?[0].text ?? ""
            self?.viewModel.fetchAuthorPosts(of: author)
            self?.navigationItem.rightBarButtonItem?.isHidden = false
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    @objc func cleanFilter() {
        viewModel.fetchPosts()
        navigationItem.rightBarButtonItem?.isHidden = true
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
        
        
        cell.update(viewModel.posts[indexPath.row])
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            CoreDataManager.shared.deletePost(posts[indexPath.row])
            viewModel.deletePost(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
