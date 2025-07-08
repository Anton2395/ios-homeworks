//
//  FeedViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    var postsList: [Post] = [Post(title: "Первый пост"), Post(title: "Второй пост")]
    private lazy var actionButtons: [UIButton] = {
        var buttons: [UIButton] = []
        for post in postsList {
            let button = UIButton()
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
        stackView.spacing = 10 // Расстояние между кнопками
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        for (actionButton, _) in zip(actionButtons, postsList) {
            stackView.addArrangedSubview(actionButton)
        }
        
        view.addSubview(stackView)
        var layOuts: [NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        
        for actionButton in actionButtons {
            layOuts.append(actionButton.heightAnchor.constraint(equalToConstant: 44))
        }
        NSLayoutConstraint.activate(layOuts)
        
        for (actionButton, post) in zip(actionButtons, postsList) {
//            actionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            actionButton.addAction(UIAction { _ in
                let postViewController = PostViewController()
                postViewController.post = post
                postViewController.modalTransitionStyle = .flipHorizontal
                postViewController.modalPresentationStyle = .fullScreen
                self.present(postViewController, animated: true)
            }, for: .touchUpInside)
        }
//
//
    }
    
//    @objc func buttonPressed(_ sender: UIButton) {
//        let postViewController = PostViewController()
//        postViewController.modalTransitionStyle = .flipHorizontal
//        postViewController.modalPresentationStyle = .fullScreen
//        
//        present(postViewController, animated: true)
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
