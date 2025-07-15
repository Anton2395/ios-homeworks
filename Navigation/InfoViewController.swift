//
//  InfoViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 12.07.25.
//

import UIKit

class InfoViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Информация"
        
        let button = UIButton(type: .system)
        button.setTitle("Показать Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        
        view.addSubview(button)
        
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
