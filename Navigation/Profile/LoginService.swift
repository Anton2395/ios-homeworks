//
//  LoginService.swift
//  Navigation
//
//  Created by Toha Shilin on 13.09.25.
//
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

enum CheckerError: LocalizedError {
    case authError(Error)
    case firestoreError(Error)
    case encodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .authError(let error):
            return (error as NSError).localizedDescription
        case .firestoreError(let error):
            return "Ошибка базы данных: \(error.localizedDescription)"
        case .encodingError:
            return "Ошибка при подготовке данных пользователя."
        case .unknown:
            return "Неизвестная ошибка."
        }
    }
}


final class Checker {
    static let shared = Checker()
    
    private let login = "admin@gmail.com"
    private let password = "123456"
    
    private init() {}
    
    private let db = Firestore.firestore().collection("users_extensions")
    
    func checkCredentials(login: String, password: String, completion: @escaping (User?) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password)
        { authResult, error in
            if let auth = authResult {
                self.db.whereField("user_id", isEqualTo: auth.user.uid).getDocuments { snapshot, error in
                    guard let document = snapshot?.documents.first else {
//                        completion(nil)
                        completion(User(
                            name: "",
                            fullName: "",
                            image: UIImage(named: ""),
                            status: ""
                        ))
                        return
                    }
                    do {
                        let user = try document.data(as: UserExtensions.self)
                        completion(User(
                            name: auth.user.email ?? "",
                            fullName: user.fullName,
                            image: UIImage(named: user.imageName),
                            status: user.status
                        ))
                    } catch {
                        print("Decode error:", error)
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func signUp(email: String, password: String, fullName: String, completion: @escaping (CheckerError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.authError(error))
                return
            }
            guard let auth = authResult else {
                completion(.unknown)
                return
            }
            do {
                try self.db.addDocument(from: UserExtensions(
                    id: nil, fullName: fullName, imageName: "Avatar", status: "tut", userId: auth.user.uid
                )) { error in
                    if let err = error {
                        completion(.firestoreError(err))
                    }
                    completion(nil)
                }
            } catch {
                completion(.encodingError(error))
            }
        }
    }
}


protocol LoginViewControllerDelegate {
    func check(login: String, password: String, completion: @escaping (User?) -> Void)
}


struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String, completion: @escaping (User?) -> Void) {
        Checker.shared.checkCredentials(login: login, password: password) { user in
            completion(user)
        }
        
    }
}
