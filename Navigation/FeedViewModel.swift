//
//  FeedViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//

final class FeedViewModel {

    enum State: Equatable {
        case idle
        case empty
        case success
        case failure
    }

    private let model: FeedModelProtocol
    private(set) var state: State = .idle

    init(model: FeedModelProtocol) {
        self.model = model
    }

    func checkPassword(_ text: String?) {
        guard let text, !text.isEmpty else {
            state = .empty
            return
        }

        if model.check(word: text) {
            state = .success
        } else {
            state = .failure
        }
    }
}

