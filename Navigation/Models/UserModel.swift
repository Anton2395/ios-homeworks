//
//  UserModel.swift
//  Navigation
//
//  Created by Toha Shilin on 8.09.25.
//
import UIKit


protocol UserService {
    var user: User { get set }
    func logIn(name: String) -> User?
}

extension UserService {
    func logIn(name: String) -> User? {
        return user.name == name ? user : nil
    }
}

class User {
    var name: String
    var fullName: String
    var image: UIImage?
    var status: String
    
    
    init(name: String, fullName: String, image: UIImage?, status: String) {
        self.name = name
        self.fullName = fullName
        self.image = image
        self.status = status
    }
}


class CurrentUserService: UserService {
    var user = User(
        name: "admin",
        fullName: "Anton Shilin",
        image: UIImage(named: "Avatar"),
        status: "tut"
    )
}

class TestUserService: UserService {
    var user = User(
        name: "admin",
        fullName: "Test User",
        image: UIImage(systemName: "person.fill"),
        status: "Debug mode user"
    )
}
