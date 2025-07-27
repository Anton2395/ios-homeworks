//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//
import UIKit

class ProfileHeaderView: UIView {
    private let startYAxsio = 80
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "My name"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setStatusButton: UIButton = {
        let button = UIButton()
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth = screenWidth - 32
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
    
    private lazy var statusTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Write new status"
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.clipsToBounds = true
        
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
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
        backgroundColor = UIColor(_colorLiteralRed: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(setStatusButton)
        addSubview(statusLabel)
        addSubview(statusTextField)
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            fullNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 10),
            setStatusButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 5),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 40)
            
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

extension ProfileHeaderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
