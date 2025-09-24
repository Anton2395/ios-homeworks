//
//  FeedViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class FeedViewController: UIViewController {
    
    let stackView = UIStackView()
    let model = FeedModel()
    
    var postsList: [PostTemp] = [PostTemp(title: "Первый пост"), PostTemp(title: "Второй пост")]
    private lazy var actionButtons: [UIButton] = {
        var buttons: [UIButton] = []
        for (index, post) in postsList.enumerated() {
            let button = CustomButton(
                title: "Перейти к посту (\(post.title))",
                titleColor: .systemBlue,
                backgroundColor: nil
            ) { [weak self] in
                self?.openPost(at: index) // напрямую передаём индекс
            }
            button.tag = index
            buttons.append(button)
        }
        return buttons
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Введите пароль"
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "write password"
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocapitalizationType = .none
        
        textField.backgroundColor = .systemGray6
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    private lazy var checkButton: UIButton = {
        let button = CustomButton(
            title: "Check",
            titleColor: .black,
            backgroundColor: .systemBlue,
            action: checkPassword
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        for (actionButton, _) in zip(actionButtons, postsList) {
            stackView.addArrangedSubview(actionButton)
        }
        
        view.addSubview(stackView)
        var layOuts: [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ]
        
        for actionButton in actionButtons {
            layOuts.append(actionButton.heightAnchor.constraint(equalToConstant: 44))
//            actionButton.addTarget(self, action: #selector(openPost(_:)), for: .touchUpInside)
        }
        NSLayoutConstraint.activate(layOuts)
        
        configuratePasswordPart()
    }
    
    private func configuratePasswordPart() {
        view.addSubview(resultLabel)
        view.addSubview(passwordTextField)
        view.addSubview(checkButton)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30),
            
            checkButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            checkButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            checkButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            checkButton.heightAnchor.constraint(equalToConstant: 20),
            
            resultLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            resultLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func openPost(at index: Int) {
        let postViewController = PostViewController()
        postViewController.post = postsList[index]
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    private func checkPassword() {
        guard let text = passwordTextField.text, !text.isEmpty else {
            resultLabel.text = "Введите слово!"
            resultLabel.textColor = .orange
            return
        }
        
        if model.check(word: text) {
            resultLabel.text = "Верно ✅"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "Неверно ❌"
            resultLabel.textColor = .systemRed
        }
    }
}
