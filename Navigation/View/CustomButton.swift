//
//  CustomButton.swift
//  Navigation
//
//  Created by Toha Shilin on 21.09.25.
//
import UIKit

class CustomButton: UIButton {
    var action: (() -> Void)?
    
    
    init(title: String, titleColor: UIColor, backgroundColor: UIColor?) {
        super.init(frame: .zero)
        configurate(title: title, titleColor: titleColor, backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurate(title: String, titleColor: UIColor, backgroundColor: UIColor?) {
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        guard let action = action else { return }
        action()
    }
}
