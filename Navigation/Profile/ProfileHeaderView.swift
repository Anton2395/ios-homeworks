//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//
import UIKit

class ProfileHeaderView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
//        imageView.frame = CGRect(x: 16, y: 16, width: 10, height: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4.0
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowRadius = 4.0
        
        button.clipsToBounds = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for something..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var newStatusText: String = ""
    
    private lazy var statusField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Write new status"
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.clipsToBounds = true
        
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
//        backgroundColor = .magenta
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(statusButton)
        addSubview(statusLabel)
        addSubview(statusField)
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 27),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            
            statusButton.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 10),
            statusButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            statusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -18),
            statusLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            
            statusField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
            statusField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            statusField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusField.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    @objc func buttonPressed() {
        statusLabel.text = newStatusText
        if let statusText = statusLabel.text, !statusText.isEmpty {
            print(statusText)
        } else {
            print("Status is empty")
        }
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        if let status = textField.text {
            newStatusText = status
        }
    }
    
}
