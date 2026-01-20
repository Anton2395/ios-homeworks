//
//  LoginViewModelTests.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//

import XCTest
@testable import Navigation

final class LoginViewModelTests: XCTestCase {

    func test_emptyFields_setsErrorState() {
        let service = LoginServiceMock()
        let viewModel = LoginViewModel(loginService: service)

        viewModel.login(login: nil, password: nil)

        XCTAssertEqual(viewModel.state, .error(.emptyField))
    }

    func test_successLogin_setsSuccessState() {
        let service = LoginServiceMock()
        service.userToReturn = User(
            name: "admin",
            fullName: "Admin Admin",
            image: nil,
            status: "online"
        )

        let viewModel = LoginViewModel(loginService: service)

        viewModel.login(login: "admin", password: "123")

        XCTAssertEqual(
            viewModel.state,
            .success(service.userToReturn!)
        )
    }

    func test_wrongPassword_setsErrorState() {
        let service = LoginServiceMock()
        service.userToReturn = nil

        let viewModel = LoginViewModel(loginService: service)

        viewModel.login(login: "admin", password: "wrong")

        XCTAssertEqual(viewModel.state, .error(.wrongPassword))
    }
}
