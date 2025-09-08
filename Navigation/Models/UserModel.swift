//
//  UserModel.swift
//  Navigation
//
//  Created by Toha Shilin on 8.09.25.
//
import UIKit


protocol UserService {
    func logIn(name: String) -> User?
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
    private let user = User(
        name: "anton",
        fullName: "Anton Shilin",
        image: UIImage(named: "Avatar"),
        status: "tut"
    )
    
    func logIn(name: String) -> User? {
        return user.name == name ? user : nil
    }
}

class TestUserService: UserService {
    private let testUser = User(
        name: "test",
        fullName: "Test User",
        image: UIImage(systemName: "person.fill"),
        status: "Debug mode user"
    )
    
    func logIn(name: String) -> User? {
        return testUser.name == name ? testUser : nil
    }
}
