//
//  LoginService.swift
//  Navigation
//
//  Created by Toha Shilin on 13.09.25.
//


final class Checker {
    static let shared = Checker()
    
    private let login = "admin"
    private let password = "12345"
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        return login == self.login && password == self.password
    }
}


protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> User?
}


struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> User? {
        if Checker.shared.check(login: login, password: password) {
            #if DEBUG
            let userService = TestUserService()
            #else
            let userService = CurrentUserService()
            #endif
            return userService.logIn(name: login)
        } else {
            return nil
        }
    }
}
