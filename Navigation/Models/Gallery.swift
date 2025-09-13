//
//  Gallery.swift
//  Navigation
//
//  Created by Toha Shilin on 28.07.25.
//

struct Gallery {
    let imageName: String
}

extension Gallery {
    static func make() -> [Gallery] {
        (1...20).compactMap { Gallery(imageName: "galery\($0)") }
    }
}
