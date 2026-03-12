//
//  PhotoTableViewCell.swift
//  Navigation
//
//  Created by Toha Shilin on 27.07.25.
//
import UIKit
import Kingfisher

class PhotoTableViewCell: UITableViewCell {
    private enum LocalizedKeys: String {
        case title = "title-profile-photo-cell"
        case addPost = "add-post-button-photo-cell"
    }
    
    var clickMoveToPhoto: (() -> Void)?
    var clickAddPost: (() -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ~LocalizedKeys.title.rawValue
        label.textColor = .photoTableTitleCell
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonForward: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let image = UIImage(systemName: "arrow.right", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .photoTableTitleCell
        button.addTarget(self, action: #selector(moveToPhotos), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var photoList: [UIImageView] = []
    
    private lazy var photoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет фото"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addPostButton: UIButton = {
        
        let button = CustomButton(
            title: ~LocalizedKeys.addPost.rawValue,
            titleColor: .systemGray,
            backgroundColor: UIColor.systemBackground,
            action: addPost
        )
        button.backgroundColor = UIColor.createColor(lightMode: .systemBackground, darkMode: .systemGray6)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(named: "ColorButton")?.cgColor
        button.layer.borderWidth = 1
        
        return button
    }()
    
    @objc func addPost() {
        clickAddPost?()
    }
    
    @objc func moveToPhotos() {
        clickMoveToPhoto?()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tuneView()
        addSubview()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    
    func tuneView() {
        contentView.backgroundColor = .photoTableCell
        accessoryType = .none
    }
    
    func addSubview() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonForward)
        contentView.addSubview(photoStackView)
        contentView.addSubview(addPostButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            buttonForward.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            buttonForward.heightAnchor.constraint(equalToConstant: 24),
            buttonForward.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            
            photoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            photoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            photoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            photoStackView.heightAnchor.constraint(equalTo: photoStackView.widthAnchor, multiplier: 0.25),
            
            
            addPostButton.topAnchor.constraint(equalTo: photoStackView.bottomAnchor, constant: 12),
            addPostButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            addPostButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addPostButton.heightAnchor.constraint(equalToConstant: 50),
            addPostButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            
        ])
        
        for photo in photoList {
            NSLayoutConstraint.activate([
                photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: 1.0)
            ])
        }
    }
    
    private func clearPhotos() {
        for view in photoStackView.arrangedSubviews {
            photoStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    private func showEmptyState() {

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        photoStackView.addArrangedSubview(emptyLabel)

    }
    
    private func showImages(_ images: [GalleryImage]) {


        for item in images {

            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.contentMode = .scaleAspectFill

            if let url = URL(string: item.imageURL) {
                imageView.kf.setImage(with: url)
            }

            photoStackView.addArrangedSubview(imageView)

//            NSLayoutConstraint.activate([
//                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
//            ])
        }
    }
    
    func configure(with images: [GalleryImage]) {
        clearPhotos()
        
        if images.isEmpty {
            showEmptyState()
        } else {
            showImages(images)
        }
    }
}
