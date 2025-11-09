//
//  InfoViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 12.07.25.
//

import UIKit

class InfoViewController: UIViewController {
    var firstTaskText: String?
    var secondTaskText: String?
    
    private lazy var labelTask: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Информация"
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        let safeArea = view.safeAreaLayoutGuide
        
//        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        configFirstTaskLabel(button)
        
    }
    
    func configFirstTaskLabel(_ button: UIButton) {
        view.addSubview(labelTask)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            labelTask.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            labelTask.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            labelTask.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            labelTask.heightAnchor.constraint(equalToConstant: 50),
        ])
        NetworkService.getToDoTask { text in
            DispatchQueue.main.async {
                self.firstTaskText = text
                self.printTaskText()
            }
        }
        NetworkService.getPlanetData { text in
            DispatchQueue.main.async {
                self.secondTaskText = text
                self.printTaskText()
            }
        }
        
    }
    
    func printTaskText() {
        labelTask.text = """
        1. \(firstTaskText ?? "-")
        2. \(secondTaskText ?? "-")
        """
    }
    
    @objc private func showAlert() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Это тестовый Alert",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            print("Нажата OK")
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in
            print("Нажата Отмена")
        })
        
        present(alert, animated: true)
    }

}
