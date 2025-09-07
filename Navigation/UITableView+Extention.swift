//
//  UITableView+Extention.swift
//  Navigation
//
//  Created by Toha Shilin on 25.07.25.
//

import UIKit

extension UITableView {
    
    func setAndlayout(headerView: UIView) {
        tableHeaderView = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        headerView.frame.size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
