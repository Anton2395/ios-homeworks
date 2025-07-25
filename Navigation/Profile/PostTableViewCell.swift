//
//  PostTableViewCell.swift
//  Navigation
//
//  Created by Toha Shilin on 25.07.25.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.backgroundColor = .systemBlue
        accessoryType = .none
    }
    
    func addSubview() {
        contentView.addSubview(label)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func update(_ post: Post) {
        label.text = post.image
    }
}
