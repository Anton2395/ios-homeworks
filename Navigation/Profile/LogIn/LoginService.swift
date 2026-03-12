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

protocol AuthService {
    func login(login: String, password: String, completion: @escaping (User?) -> Void)
    func loadUser(completion: @escaping (User?) -> Void)
    func logout()
}

final class Checker: AuthService {
    static let shared = Checker()
    
    private init() {}
    
    private let db = Firestore.firestore().collection("users_extensions")
    
    func loginStatus() -> Bool {
        if let currentUser = Auth.auth().currentUser {
            return true
        } else {
            return false
        }
    }
    
    func loadUser(completion: @escaping (User?) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        db.document(currentUser.uid).getDocument { snapshot, error in
            
            if let error = error {
                print("Firestore read error:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                completion(nil)
                return
            }
            
            do {
                let userExtensions = try snapshot.data(as: UserExtensions.self)
                
                let user = User(
                    name: currentUser.email ?? "",
                    fullName: userExtensions.fullName,
                    image: userExtensions.imageName,
                    status: userExtensions.status,
                    deleteImageURL: userExtensions.deleteImageURL
                )
                
                completion(user)
                
            } catch {
                print("Decode error:", error)
                completion(nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Logout error:", error)
        }
    }
    
    func login(login: String, password: String, completion: @escaping (User?) -> Void) {
        print(login, password)
        
        Auth.auth().signIn(withEmail: login, password: password) { authResult, error in
            if let error = error {
                print("Login error:", error.localizedDescription)
                completion(nil)
                return
            }
            guard let auth = authResult else {
                completion(nil)
                return
            }
            
            self.db.document(auth.user.uid).getDocument { snapshot, error in
                if let error = error {
                    print("Firestore read error:", error.localizedDescription)
                    completion(nil)
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    print("User document does not exist")
                    completion(nil)
                    return
                }
                
                do {
                    let userExtensions = try snapshot.data(as: UserExtensions.self)
                    
                    completion(User(
                        name: auth.user.email ?? "",
                        fullName: userExtensions.fullName,
                        image: userExtensions.imageName,
                        status: userExtensions.status,
                        deleteImageURL: userExtensions.deleteImageURL
                    ))
                } catch {
                    print("Decode error:", error)
                    completion(nil)
                }
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
                try self.db.document(auth.user.uid).setData(from: UserExtensions(
                    id: nil,
                    fullName: fullName,
                    imageName: "",
                    deleteImageURL: "",
                    status: "Hi everybody!)",
                    userId: auth.user.uid
                )) { error in
                    if let err = error {
                        completion(.firestoreError(err))
                    } else {
                        completion(nil)
                    }
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
        Checker.shared.login(login: login, password: password) { user in
            completion(user)
        }
        
    }
}
