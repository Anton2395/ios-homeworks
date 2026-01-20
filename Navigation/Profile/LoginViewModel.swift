//
//  LoginViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 19.01.26.
//

final class LoginViewModel {

    enum State: Equatable {
        case idle
        case loading
        case success(User)
        case error(ApiError)
        
        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading):
                return true
                
            case (.success(let lUser), .success(let rUser)):
                return lUser.name == rUser.name &&
                       lUser.fullName == rUser.fullName &&
                       lUser.status == rUser.status
                       
            case (.error(let lError), .error(let rError)):
                return lError == rError
                
            default:
                return false
            }
        }
    }


    private(set) var state: State = .idle {
        didSet {
            onStateChange?(state)
        }
    }

    var onStateChange: ((State) -> Void)?

    private let loginService: LoginViewControllerDelegate

    init(loginService: LoginViewControllerDelegate) {
        self.loginService = loginService
    }

    func login(login: String?, password: String?) {
        guard
            let login,
            let password,
            !login.isEmpty,
            !password.isEmpty
        else {
            state = .error(.emptyField)
            return
        }

        state = .loading

        loginService.check(login: login, password: password) { [weak self] user in
            guard let self else { return }

            if let user {
                self.state = .success(user)
            } else {
                self.state = .error(.wrongPassword)
            }
        }
    }
}
