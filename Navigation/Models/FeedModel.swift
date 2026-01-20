//
//  FeedModel.swift
//  Navigation
//
//  Created by Toha Shilin on 21.09.25.
//

class FeedModel {
    private var secretWord: String = "test"
    
    func check(word: String) -> Bool { secretWord == word }
}


protocol FeedModelProtocol {
    func check(word: String) -> Bool
}

extension FeedModel: FeedModelProtocol {}
