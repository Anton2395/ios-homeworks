//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Toha Shilin on 25.07.25.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {
    private enum LocalizedKeys: String {
        case viewsPost = "views-post-cell-profile-vc"
    }
    
    var post: Post?
    var isLiked: Bool?
    var isBookmark: Bool?
    
    var onBookmark: ((Post) -> Void)?
    var unBookmark: ((Post) -> Void)?
    
    var onLikePost: ((Post) -> Void)?
    var unlikePost: ((Post) -> Void)?
    
    
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .postMainTextCell
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(bookmarkTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imagePostView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .postMainTextCell
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(clickLike), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .postMainTextCell
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tuneView()
        addSubview()
        setConstraints()
        
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(doubleTapPost))
        addGestureRecognizer(doubleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func tuneView() {
        contentView.backgroundColor = .postBackCell
        accessoryType = .none
        
    }
    
    func addSubview() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(imagePostView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likeLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(viewsLabel)
        contentView.addSubview(bookmarkButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bookmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            
            imagePostView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            imagePostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagePostView.heightAnchor.constraint(equalTo: imagePostView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: imagePostView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            
            likeLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            
            
            viewsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc func doubleTapPost() {
        guard let post = post, let isLiked = isLiked else { return }
        if !isLiked {
            onLikePost?(post)
        }
    }
    
    @objc func clickLike() {
        guard let post = post, let isLiked = isLiked else { return }
        print("click like \(post.id ?? "??")")
        if isLiked {
            unlikePost?(post)
        } else {
            onLikePost?(post)
        }
    }
    
    @objc func bookmarkTap() {
        guard let post = post, let isBookmark = isBookmark else { return }
        if isBookmark {
            unBookmark?(post)
            setBookmarkPost(status: false)
        } else {
            onBookmark?(post)
            setBookmarkPost(status: true)
        }
    }
    
    func setBookmarkPost(status: Bool) {
        let configBookmark = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        bookmarkButton.setImage(
            UIImage(
                systemName: status ? "bookmark.fill" : "bookmark",
                withConfiguration: configBookmark
            ),
            for: .normal
        )
    }
    
    func update(_ post: Post, isLiked: Bool = false, isBookmark: Bool = false, isSavedView: Bool = false) {
        self.post = post
        self.isLiked = isLiked
        self.isBookmark = isBookmark
        authorLabel.text = post.author
        if post.imageURL == "" {
            imagePostView.image = UIImage(systemName: "photo.fill")
        } else {
            let url = URL(string: post.imageURL)
            let processor = DownsamplingImageProcessor(size: imagePostView.bounds.size)
            imagePostView.kf.indicatorType = .activity
            imagePostView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo.fill"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ]
            )
        }
        descriptionLabel.text = post.description
        if !isSavedView {
            likeLabel.text = "\(post.likes)"
            viewsLabel.text = "\(~LocalizedKeys.viewsPost.rawValue): \(post.views)"
            
            
            let configLike = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            likeButton.setImage(
                UIImage(
                    systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup",
                    withConfiguration: configLike
                ),
                for: .normal)
            
            
            setBookmarkPost(status: isBookmark)
        } else {
            likeLabel.isHidden = true
            viewsLabel.isHidden = true
            likeButton.isHidden = true
            bookmarkButton.isHidden = true
        }
    }
}
