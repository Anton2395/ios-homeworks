//
//  FullScreenImageViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 5.03.26.
//

import UIKit
import Kingfisher

class FullScreenImageViewController: UIViewController {
    private enum LocalizedKeys: String {
        case setAvatart = "set-avatar-button-full-screen-vc"
        case deleteImage = "delete-button-full-screen-vc"
    }
    
    var setNewAvatar: ((ImgBBUploadResult) -> Void)?
    var deleteImage: ((GalleryImage) -> Void)?
    private var userImage: String
    
    var images: [GalleryImage]
    var index: Int
    private var currentImage: GalleryImage {
        images[index]
    }
    
    private var rangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 18
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 18
        button.showsMenuAsPrimaryAction = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init(images: [GalleryImage], workIndexImage: Int, userImage: String) {
        self.userImage = userImage
        self.images = images
        index = workIndexImage
        rangeLabel.text = "\(index+1)/\(images.count)"
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupSubviews()
        setupActions()
        setupConstraints()

    }
    
    func setupSubviews() {
        view.addSubview(imageView)
        view.addSubview(closeButton)
        view.addSubview(menuButton)
        view.addSubview(rangeLabel)
    }
    
    func setupActions() {
        if let url = URL(string: currentImage.imageURL) {
            imageView.kf.setImage(with: url)
        }
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        updateMenu()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeLeft.direction = .left
        imageView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gesture:)))
        swipeRight.direction = .right
        imageView.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closeTapped))
        swipeDown.direction = .down
        imageView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(closeTapped))
        swipeUp.direction = .up
        imageView.addGestureRecognizer(swipeUp)
        
        
        
    }
    
    @objc func swipe(gesture: UISwipeGestureRecognizer) {
        let startIndex = index
        if gesture.direction == .left {
            if index == (images.count-1) {
                index = 0
            } else {
                index += 1
            }
        } else if gesture.direction == .right {
            if index == 0 {
                index = images.count-1
            } else {
                index -= 1
            }
        }
        if startIndex != index {
            setImage()
        }
        
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            rangeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            rangeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            menuButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            menuButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func updateMenu() {
        let tapShare = UIAction(title: ~LocalizedKeys.setAvatart.rawValue, image: UIImage(systemName: "photo.fill")) { [weak self] _ in
            guard let self = self else { return }
            let image = ImgBBUploadResult(
                url: currentImage.imageURL,
                deleteURL: currentImage.deleteImageURL
            )
            setNewAvatar?(image)
        }

        let tapDelete = UIAction(
            title: ~LocalizedKeys.deleteImage.rawValue,
            image: UIImage(systemName: "trash"),
            attributes: currentImage.imageURL == userImage ? [.disabled] : []
        ) { [weak self] _ in
            guard let self = self else { return }
            deleteImage?(currentImage)
            images.remove(at: index)
            
            if images.isEmpty {
                closeTapped()
                return
            }

            if index >= images.count {
                index = images.count - 1
            }
            setImage()
        }

        menuButton.menu = UIMenu(children: [tapShare, tapDelete])
    }
    
    func setImage() {
        guard !images.isEmpty else {
            closeTapped()
            return
        }
        if let url = URL(string: currentImage.imageURL) {
            UIView.transition(
                with: imageView,
                duration: 0.25,
                options: .transitionCrossDissolve
            ) {
                self.imageView.kf.setImage(with: url)
            }
        }
        rangeLabel.text = "\(index+1)/\(images.count)"
        updateMenu()
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

}
