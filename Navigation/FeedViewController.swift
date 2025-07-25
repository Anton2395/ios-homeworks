//
//  FeedViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    var postsList: [PostTemp] = [PostTemp(title: "Первый пост"), PostTemp(title: "Второй пост")]
    private lazy var actionButtons: [UIButton] = {
        var buttons: [UIButton] = []
        for (index, post) in postsList.enumerated() {
            let button = UIButton()
            button.tag = index
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Перейти к посту (\(post.title))", for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            buttons.append(button)
        }
        return buttons
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        let stackView = UIStackView()
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
//            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ]
        
        for actionButton in actionButtons {
            layOuts.append(actionButton.heightAnchor.constraint(equalToConstant: 44))
            actionButton.addTarget(self, action: #selector(openPost(_:)), for: .touchUpInside)
        }
        NSLayoutConstraint.activate(layOuts)
    }
    
    @objc func openPost(_ sender: UIButton) {
        let postViewController = PostViewController()
        postViewController.post = postsList[sender.tag]
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
