//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//

import UIKit
import Photos

class ProfileViewController: UIViewController {
    private enum LocalizedKeys: String {
        case titleAlert = "title-alert-access-photo-profile-vc"
        case messageAlert = "description-alert-access-photo-profile-vc"
        case cancelAlert = "cancel-alert-access-photo-profile-vc"
        case settingsAlert = "settings-alert-access-photo-profile-vc"
    }
    
    private let viewModel: ProfileViewModel
    
    var showPhotosCollection: ((String) -> Void)?
    var logoutPressed: (() -> Void)?
    
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .headerProfileBack
        tableView.dragInteractionEnabled = true
        
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
    
    private var avatarPhotoPickerDelegate: CustomPhotoPickerDelegate?
    
    private enum CellReuseID: String {
        case photo = "PhotoTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
    }
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        headerView.setupUserParam(user: viewModel.user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel.loadGalleryPreview()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        viewModel.loadPosts()
        viewModel.loadGalleryPreview()
    }
    
    
    @objc private func didTapAddPost() {
        print("Добавить пост")
        let postFormVC = PostFormViewController { [weak self] description, image in
            guard let self = self else { return }
            self.viewModel.addPost(description, img: image)
        }
        present(postFormVC, animated: true)
    }
    
    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        headerView.avatarImageView.isUserInteractionEnabled = true
        headerView.avatarImageView.addGestureRecognizer(tap)
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    @objc func didTapClose() {
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
        guard let window = view.window else { return }
        guard headerView.avatarImageView.image != UIImage(systemName: "person.fill") else {
            let picker = UIImagePickerController()
            avatarPhotoPickerDelegate = CustomPhotoPickerDelegate(handleChoosedImage: { image in
                print(image)
                Task {
                    ImgBBService.upload(image: image) { result in
                        switch result {
                        case .success(let url):
                            FirebaseService.updateAvatar(url) { error in
                                if let error = error {
                                    print("Ошибка при обновлении аватара:", error.localizedDescription)
                                } else {
                                    print("Аватар успешно обновлён!")
                                }
                            }
                        case .failure(let error):
                            print("Ошибка загрузки на ImgBB:", error.localizedDescription)
                        }
                    }
                }
            })
            picker.sourceType = .photoLibrary
            picker.delegate = avatarPhotoPickerDelegate
            requestPhotoLibraryAccess { [weak self] status in
                if status {
                    self?.present(picker, animated: true)
                } else {
                    self?.showPhotoAccessDeniedAlert()
                }
            }
            
            return
        }
        
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
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status {
            
        case .authorized, .limited:
            DispatchQueue.main.async {
                completion(true)
            }
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited)
                }
            }
            
        default:
            completion(false)
        }
    }
    
    func showPhotoAccessDeniedAlert() {
        let alert = UIAlertController(
            title: ~LocalizedKeys.titleAlert.rawValue,
            message: ~LocalizedKeys.messageAlert.rawValue,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: ~LocalizedKeys.cancelAlert.rawValue, style: .cancel))
        
        alert.addAction(UIAlertAction(title: ~LocalizedKeys.settingsAlert.rawValue, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        })
        
        present(alert, animated: true)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
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
        
        viewModel.updateAvatar = { [weak self] newAvatar in
            self?.headerView.setNewAvatar(newAvatar)
        }
        headerView.onStatusUpdated = { [weak self] newStatus in
            guard let self = self else { return }
            self.viewModel.loadNewStatus(newStatus)
        }
        headerView.logoutPressed = { [weak self] in
            self?.logoutPressed?()
        }
        tableView.setAndlayout(headerView: headerView)
        tableView.tableFooterView = UIView()
        
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: CellReuseID.photo.rawValue)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.custom.rawValue)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
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
            cell.configure(with: self.viewModel.galleryImages)
            cell.clickMoveToPhoto = { [weak self] in
                guard let self = self else { return }
                self.showPhotosCollection?(self.viewModel.user.image)
            }
            cell.clickAddPost = { [weak self] in
                self?.didTapAddPost()
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
                
//                viewModel.setViewPost(postId: post.id)
                cell.update(
                    post,
                    isLiked: viewModel.isPostLiked(post),
                    isBookmark: RealmService.shared.isSaved(id: post.id ?? "")
                )
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
            print(1)
        default:
            print("Did nothing")
        }
    }
}
