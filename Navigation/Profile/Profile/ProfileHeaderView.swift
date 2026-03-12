//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Toha Shilin on 15.07.25.
//
import UIKit
import Kingfisher

class ProfileHeaderView: UIView {
    private enum LocalizedKeys: String {
        case placeholderStatus = "placeholder-status-header-profile-vc"
    }
    
    var logoutPressed: (() -> Void)?
    
    lazy var buttonSettings: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let logoutAction = UIAction(
            title: "Exit",
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.logoutPressed?()
        }
        let menu = UIMenu(children: [logoutAction])
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.avatarBorder.cgColor
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .fullNameColorText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        label.accessibilityHint = "Tap to edit status"
        
        return label
    }()
    
    private lazy var statusTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = ~LocalizedKeys.placeholderStatus.rawValue
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        
        textField.backgroundColor = .statusField
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.clipsToBounds = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        
        textField.isHidden = true
        
        return textField
    }()
    
    
    
    private lazy var saveStatusButton: UIButton = {
        var config = UIButton.Configuration.plain() 
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        config.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: iconConfig)
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        config.baseForegroundColor = .systemGreen
        let button = UIButton(configuration: config)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveStatusTapped), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    
    // MARK: - Properties
    
    private var currentStatus: String = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = UIColor.headerProfileBack
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(saveStatusButton)
        addSubview(buttonSettings)
        
        let safeArea = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Avatar
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            
            buttonSettings.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            buttonSettings.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            buttonSettings.widthAnchor.constraint(equalToConstant: 40),
            buttonSettings.heightAnchor.constraint(equalToConstant: 40),
            
            
            // Full Name
            fullNameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            // Status Label (режим просмотра)
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -16),
            
            // Status TextField (режим редактирования) — те же позиции, что у label
            statusTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            statusTextField.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusTextField.trailingAnchor.constraint(equalTo: saveStatusButton.leadingAnchor, constant: -8),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Save Button (справа от textField)
            saveStatusButton.centerYAnchor.constraint(equalTo: statusTextField.centerYAnchor),
            saveStatusButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            saveStatusButton.widthAnchor.constraint(equalToConstant: 30),
            saveStatusButton.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    // MARK: - Public Methods
    
    func setupUserParam(user: User?) {
        guard let user = user else { return }
        
        if user.image.isEmpty {
            avatarImageView.image = UIImage(systemName: "person.fill")
        } else if let url = URL(string: user.image) {
            avatarImageView.kf.setImage(with: url)
        }
        
        fullNameLabel.text = user.fullName
        currentStatus = user.status
        statusLabel.text = currentStatus
        statusTextField.text = currentStatus
    }
    
    // MARK: - Actions
    
    @objc private func statusLabelTapped() {
        statusTextField.text = currentStatus
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.statusLabel.isHidden = true
            self.statusTextField.isHidden = false
            self.saveStatusButton.isHidden = false
        }
        
        statusTextField.becomeFirstResponder()
    }
    
    @objc private func saveStatusTapped() {
        if let newText = statusTextField.text {
            currentStatus = newText
            statusLabel.text = newText
            
            onStatusUpdated?(newText)
        }
        
        statusTextField.resignFirstResponder()
        
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) {
            self.statusTextField.isHidden = true
            self.saveStatusButton.isHidden = true
            self.statusLabel.isHidden = false
        }
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
    }
    
    // MARK: - Callback для View Controller
    
    var onStatusUpdated: ((String) -> Void)?
    
    func setNewAvatar(_ newAvatar: ImgBBUploadResult) {
        if let url = URL(string: newAvatar.url) {
            avatarImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ProfileHeaderView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveStatusTapped()
        return true
    }
    
}
