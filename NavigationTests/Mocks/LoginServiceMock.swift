//
//  LoginServiceMock.swift
//  Navigation
//
//  Created by Toha Shilin on 20.01.26.
//
@testable import Navigation

final class LoginServiceMock: LoginViewControllerDelegate {

    var userToReturn: User?

    func check(
        login: String,
        password: String,
        completion: @escaping (User?) -> Void
    ) {
        completion(userToReturn)
    }
}
