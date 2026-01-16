//
//  LocalizationShortcut.swift
//  Navigation
//
//  Created by Toha Shilin on 16.01.26.
//
import Foundation

prefix operator ~
prefix func ~ (string: String) -> String {
    if #available(iOS 15, *) {
        return String(localized: String.LocalizationValue(string), comment: "")
    } else {
        return NSLocalizedString(string, comment: "")
    }
}

@available(iOS 16, *)
prefix func ~ (_ resource: LocalizedStringResource) -> String {
    String(localized: resource)
}
