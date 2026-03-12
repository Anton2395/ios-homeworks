//
//  RegistrationViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 9.11.25.
//
import UIKit
import FirebaseAuth


class RegistrationViewController: UIViewController {
    private enum LocalizedKeys: String {
        case filledFieldsMessage = "filled-fields-message-reg-vc"
        case errorTitleAlert = "error-title-alert-reg-vc"
        case nameForm = "name-form-reg-vc"
        case emailPlaceholder = "email-place-holder-login-vc"
        case passwordPlaceholder = "password-place-holder-login-vc"
        case fullNamePlaceholder = "full-name-placeholder-reg-vc"
        case signUpButton = "title-button-sign-up-login-vc"
        case backButton = "back-button-reg-vc"
        
        case emailError = "email-is-used-error-reg-vc"
        case emailFormatError = "wrong-email-error-reg-vc"
        case shortPasswordError = "short-password-error-reg-vc"
        case networkError = "network-error-reg-vc"
        case saveDbError = "save-db-error-reg-vc"
        case readDataError = "read-user-data-error-reg-vc"
        case someError = "something-wrong-error-reg-vc"
        case errorTitle = "just-error-reg-vc"
    }
    
    var onLogin: (() -> Void)?
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ~LocalizedKeys.nameForm.rawValue
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
        
    private lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ~LocalizedKeys.emailPlaceholder.rawValue
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        
        textField.layer.cornerRadius = 10
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ~LocalizedKeys.passwordPlaceholder.rawValue
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        
        textField.layer.cornerRadius = 10
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        
        textField.isSecureTextEntry = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var fullNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ~LocalizedKeys.fullNamePlaceholder.rawValue
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        
        textField.layer.cornerRadius = 10
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.backgroundColor = .systemGray6
        textField.isUserInteractionEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = CustomButton(
            title: ~LocalizedKeys.signUpButton.rawValue,
            titleColor: .systemGray,
            backgroundColor: UIColor.systemBackground,
            action: pressedSignUp
        )
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(named: "ColorButton")?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = CustomButton(
            title: ~LocalizedKeys.backButton.rawValue,
            titleColor: .white,
            backgroundColor: UIColor.systemGray,
            action: pressedBack
        )
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    func pressedSignUp() {
        guard let email = emailField.text, let password = passwordField.text, let fullName = fullNameField.text else {
            showAlert(~LocalizedKeys.filledFieldsMessage.rawValue)
            return
        }
        
        Checker.shared.signUp(email: email, password: password, fullName: fullName) { [weak self] error in
            guard let self = self else {
                return
            }
            if let error = error {
                print(error)
                self.showErrorAlert(for: error)
            } else {
                self.onLogin?()
            }
        }
    }
    
    func pressedBack() {
        onLogin?()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroudnRegForm
        
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(fullNameField)
        contentView.addSubview(signUpButton)
        contentView.addSubview(backButton)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            emailField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            fullNameField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            fullNameField.leadingAnchor.constraint(equalTo: passwordField.leadingAnchor),
            fullNameField.trailingAnchor.constraint(equalTo: passwordField.trailingAnchor),
            fullNameField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: fullNameField.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: fullNameField.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            backButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    func showAlert(_ alertMessage: String) {
        let alert = UIAlertController(
            title: ~LocalizedKeys.errorTitleAlert.rawValue,
            message: alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func showErrorAlert(for error: CheckerError) {
        let message: String
        
        switch error {
        case .authError(let authError):
            let nsError = authError as NSError
            switch nsError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                message = ~LocalizedKeys.emailError.rawValue
            case AuthErrorCode.invalidEmail.rawValue:
                message = ~LocalizedKeys.emailFormatError.rawValue
            case AuthErrorCode.weakPassword.rawValue:
                message = ~LocalizedKeys.shortPasswordError.rawValue
            case AuthErrorCode.networkError.rawValue:
                message = ~LocalizedKeys.networkError.rawValue
            default:
                message = nsError.localizedDescription
            }
            
        case .firestoreError:
            message = ~LocalizedKeys.saveDbError.rawValue
            
        case .encodingError:
            message = ~LocalizedKeys.readDataError.rawValue
            
        case .unknown:
            message = ~LocalizedKeys.someError.rawValue
        }
        
        let alert = UIAlertController(title: ~LocalizedKeys.errorTitle.rawValue, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
