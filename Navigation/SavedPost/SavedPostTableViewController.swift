//
//  SavedPostTableViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 2.12.25.
//

import UIKit
import CoreData
import StorageService


class SavedPostTableViewController: UITableViewController {
    
    var viewModel: SavedPostViewModel
    
    lazy var fetchResultController = {
        let request = SavedPost.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "author", ascending: true)
        ]
        let fetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchController.delegate = self
        return fetchController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        setupNavigation()
        try? fetchResultController.performFetch()
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
            self?.fetchResultController.fetchRequest.predicate = NSPredicate(format: "author == %@", author)

            try? self?.fetchResultController.performFetch()
            self?.tableView.reloadData()
            self?.navigationItem.rightBarButtonItem?.isHidden = false
        }
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    @objc func cleanFilter() {
        fetchResultController.fetchRequest.predicate = nil
        try? fetchResultController.performFetch()
        tableView.reloadData()
        navigationItem.rightBarButtonItem?.isHidden = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostTableViewCell_ReuseID",
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        let post = fetchResultController.object(at: indexPath)
        
        cell.update(Post(
            author: post.author ?? "",
            description: post.pDescription ?? "",
            image: post.image ?? "",
            likes: 0,
            views: 0
        ))
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let object = fetchResultController.object(at: indexPath)
            viewModel.deletePost(object)
        } else if editingStyle == .insert {
        }    
    }
}

extension SavedPostTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadData()
        @unknown default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
