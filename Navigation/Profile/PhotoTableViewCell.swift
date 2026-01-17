//
//  PhotoTableViewCell.swift
//  Navigation
//
//  Created by Toha Shilin on 27.07.25.
//
import UIKit

class PhotoTableViewCell: UITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photo"
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var photoList: [UIImageView] = {
        var imageViewList: [UIImageView] = []
        for image in 1...4 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "galery\(image)")
            imageView.layer.cornerRadius = 6
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageViewList.append(imageView)
        }
        return imageViewList
    }()
    
    private lazy var photoStackView: UIStackView = {
        let stackView = UIStackView()
        for photo in photoList {
            stackView.addArrangedSubview(photo)
        }
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
            photoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
        for photo in photoList {
            NSLayoutConstraint.activate([
                photo.heightAnchor.constraint(equalTo: photo.widthAnchor, multiplier: 1.0)
            ])
        }
    }
}
