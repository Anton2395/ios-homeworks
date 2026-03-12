//
//  UIColor+Extention.swift
//  Navigation
//
//  Created by Toha Shilin on 17.01.26.
//
import UIKit

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
    static let headerProfileBack: UIColor = createColor(
        lightMode: UIColor(_colorLiteralRed: 242/255, green: 242/255, blue: 247/255, alpha: 1.0),
        darkMode: .systemGray6
    )
    static let avatarBorder: UIColor = createColor(lightMode: .white, darkMode: .systemGray3)
    static let fullNameColorText: UIColor = createColor(lightMode: .black, darkMode: .white)
    static let statusField: UIColor = createColor(lightMode: .white, darkMode: .systemGray3)
    static let photoTableCell: UIColor = createColor(lightMode: .white, darkMode: .black)
    static let photoTableTitleCell: UIColor = createColor(lightMode: .black, darkMode: .white)
    static let postBackCell: UIColor = .systemBackground
    static let postMainTextCell: UIColor = createColor(lightMode: .black, darkMode: .white)
    static let backgroudnRegForm: UIColor = createColor(
        lightMode: UIColor(red: 0.282, green: 0.522, blue: 0.8, alpha: 1),
        darkMode: .systemGray3
    )
}

