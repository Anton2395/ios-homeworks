//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Toha Shilin on 2.02.26.
//
import LocalAuthentication


final class LocalAuthorizationService {
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Enter Username and Password"
        var laError: NSError?
        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        
        guard context.canEvaluatePolicy(policy, error: &laError) else {
            print(laError?.localizedDescription ?? "Can't evaluate policy")
            authorizationFinished(true)
            return
        }
        Task {
            do {
                try await context.evaluatePolicy(policy, localizedReason: "Log in to your account")
                authorizationFinished(true)
            } catch {
                print(error.localizedDescription)
                authorizationFinished(false)
            }
        }
        
    }
}
