//
//  LoginFactory.swift
//  Navigation
//
//  Created by Toha Shilin on 13.09.25.
//

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
}
