//
//  FeedViewModelTests.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//

import XCTest
@testable import Navigation

final class FeedViewModelTests: XCTestCase {

    func test_emptyPassword_setsEmptyState() {
        let model = FeedModelMock()
        let viewModel = FeedViewModel(model: model)

        viewModel.checkPassword(nil)

        XCTAssertEqual(viewModel.state, .empty)
    }

    func test_correctPassword_setsSuccessState() {
        let model = FeedModelMock()
        model.result = true
        let viewModel = FeedViewModel(model: model)

        viewModel.checkPassword("test")

        XCTAssertEqual(viewModel.state, .success)
    }

    func test_wrongPassword_setsFailureState() {
        let model = FeedModelMock()
        model.result = false
        let viewModel = FeedViewModel(model: model)

        viewModel.checkPassword("wrong")

        XCTAssertEqual(viewModel.state, .failure)
    }
}
