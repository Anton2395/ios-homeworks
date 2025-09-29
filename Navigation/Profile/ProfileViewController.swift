//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//

import UIKit
import StorageService

class ProfileViewController: UIViewController {
    // MARK: - Data
    fileprivate let data = Post.make()
    
    private let viewModel: ProfileViewModel
    
    var showPhotosCollection: (() -> Void)?
    
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(_colorLiteralRed: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        
        return tableView
    }()
    
    let headerView = ProfileHeaderView()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var animatedAvatarView: UIImageView?
    private var avatarOriginalFrame: CGRect = .zero
    
    private enum CellReuseID: String {
        case photo = "PhotoTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    // MARK: - Init
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
        super.init(nibName: nil, bundle: nil)
        headerView.setupUserParam(user: user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setSubview()
        setConstraints()
        
        setupActions()
        
        tuneTableView()
        
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        headerView.avatarImageView.isUserInteractionEnabled = true
        headerView.avatarImageView.addGestureRecognizer(tap)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    @objc func didTapClose() {
        print("close close close")
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.closeButton.alpha = 0
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.5,
                    animations: {
                        self.animatedAvatarView?.frame = self.avatarOriginalFrame
                        self.animatedAvatarView?.layer.cornerRadius = self.headerView.avatarImageView.layer.cornerRadius
                        self.overlayView.alpha = 0
                    },
                    completion: { _ in
                        self.animatedAvatarView?.removeFromSuperview()
                        self.overlayView.removeFromSuperview()
                        self.closeButton.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    @objc func didTapAvatar() {
        print("tap tap tap")
        guard let window = view.window else { return }
        
        avatarOriginalFrame = headerView.avatarImageView.convert(headerView.avatarImageView.bounds, to: window)
        
        let avatar = UIImageView(
            image: headerView.avatarImageView.image
        )
        avatar.contentMode = .scaleAspectFit
        avatar.clipsToBounds = true
        avatar.frame = avatarOriginalFrame
        avatar.layer.cornerRadius = headerView.avatarImageView.layer.cornerRadius
        animatedAvatarView = avatar
        window.addSubview(overlayView)
        window.addSubview(avatar)
        window.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: window.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: window.safeAreaAspectFitLayoutGuide.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        window.layoutIfNeeded()
        
        let targetWidth = window.bounds.width
        let aspectRatio = avatar.frame.height / avatar.frame.width
        let targetHeight = targetWidth * aspectRatio
        let targetFrame = CGRect(x: 0, y: (window.bounds.height - targetHeight)/2, width: targetWidth, height: targetHeight)
        
        
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.animatedAvatarView?.frame = targetFrame
                self.animatedAvatarView?.layer.cornerRadius = 0
                self.overlayView.alpha = 0.5
            },
            completion:{ _ in
                UIView.animate(withDuration: 0.3) {
                    self.closeButton.alpha = 1
                }
                print(targetFrame)
                print("finish")
            }
        )
    }
    
    func setupView() {
        view.backgroundColor = UIColor(_colorLiteralRed: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        
        #if DEBUG
        view.backgroundColor = .systemGreen
        #else
        view.backgroundColor = .systemBlue
        #endif
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
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfRows(in: section)
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
            
            if let post = viewModel.post(at: indexPath) {
                cell.update(post)
            }
            return cell
        default:
            fatalError("unexpected section")
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You select \(indexPath.section) - section and \(indexPath.row) - row")
        switch indexPath.section {
        case 0:
            showPhotosCollection?()
        default:
            print("Did nothing")
        }
    }
}
