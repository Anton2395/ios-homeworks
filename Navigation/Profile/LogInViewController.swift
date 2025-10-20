//
//  LogInViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 22.07.25.
//

import UIKit


class LogInViewController: UIViewController {
    
    var loginDelegate: LoginViewControllerDelegate?
    
    var onLoginSuccess: ((User) -> Void)?
    
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
    
    private lazy var logoImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "VK_logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var emailPhoneField: UITextField = { [unowned self] in
        let textField = UITextField()
        textField.placeholder = "Email or phone"
        textField.text = "admin"
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        
        textField.backgroundColor = .systemGray6
        textField.isUserInteractionEnabled = true
        
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.text = "12345"
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        
        textField.backgroundColor = .systemGray6
        
        textField.isSecureTextEntry = true
        
        textField.delegate = self
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        return stackView
    }()
    
    private lazy var viewBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var loginButton: UIButton = {
        let button = CustomButton(
            title: "Log In",
            titleColor: .white,
            backgroundColor: UIColor(named: "ColorButton"),
            action: pressedLogin
        )
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0.0
        scrollView.contentInset.bottom = keyboardHeight
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    func pressedLogin() {
        do {
            try self.processLogin()
        } catch ApiError.emptyField {
            let alert = UIAlertController(
                title: "Ошибка ввода",
                message: "Поля должны быть заполнены",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        } catch ApiError.wrongPassword {
            let alert = UIAlertController(
                title: "Ошибка входа",
                message: "Неверное имя пользователя",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true)
        } catch {
            print("Something wrong")
        }
    }
    
    func processLogin() throws {
        guard let login = emailPhoneField.text, let password = passwordField.text else {
            throw ApiError.emptyField
        }
        if let user = loginDelegate?.check(login: login, password: password) {
            onLoginSuccess?(user)
        } else {
            throw ApiError.wrongPassword
        }
    }
    
    
    func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func addSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        textFieldsStackView.addArrangedSubview(emailPhoneField)
        
        textFieldsStackView.addArrangedSubview(viewBorder)
        textFieldsStackView.addArrangedSubview(passwordField)
        contentView.addSubview(textFieldsStackView)
        
        contentView.addSubview(loginButton)
        
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
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            textFieldsStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            textFieldsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            emailPhoneField.heightAnchor.constraint(equalToConstant: 50),
            viewBorder.heightAnchor.constraint(equalToConstant: 0.5),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    
    func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self)
    }
    
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
