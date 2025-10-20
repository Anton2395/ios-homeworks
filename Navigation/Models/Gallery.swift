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
    static func make(completion: (Result<[Gallery], ApiError>) -> Void)  {
        completion(.success((1...20).compactMap { Gallery(imageName: "galery\($0)") }))
    }
}
