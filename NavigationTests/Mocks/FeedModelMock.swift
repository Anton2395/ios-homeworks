//
//  FeedModelMock.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//
@testable import Navigation

final class FeedModelMock: FeedModelProtocol {
    var result: Bool = false

    func check(word: String) -> Bool {
        result
    }
}
