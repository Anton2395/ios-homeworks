//
//  PostViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 7.07.25.
//

import UIKit

class PostViewController: UIViewController {
    
    let button: UIButton = UIButton()
    var post: Post = Post(title:"")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        self.title = "Пост"
        
        button.setTitle("Back", for: .normal)
        view.addSubview(button)
        
        button.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct Post {
 var title: String
}
