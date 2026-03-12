//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Toha Shilin on 28.07.25.
//
import UIKit
import Kingfisher

class PhotosCollectionViewCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    func setupView() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
    }
    
    func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setup(with photoName: String) {
        imageView.image = UIImage(named: photoName)
    }
    
    func setup(with photo: UIImage) {
        imageView.image = photo
    }
    
    func setup(with photo: GalleryImage) {
        if let url = URL(string: photo.imageURL) {
            imageView.kf.setImage(with: url)
        }
    }
}
