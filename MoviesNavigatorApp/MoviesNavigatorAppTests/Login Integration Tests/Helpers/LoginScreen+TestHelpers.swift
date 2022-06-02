//
//  LoginScreen+TestHelpers.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import AuthenticationiOS
import UIKit

extension LoginViewController {
    
    func simulateUserSentLoginRequest() {
        loginLoadingViewController?.loginButton.send(event: .touchUpInside)
    }
    
    func simulateUserFilledLoginData(user: String = "any-user", password: String = "any-password") {
        ui.userTextField.type(user)
        ui.passwordTextField.type(password)
    }
    
    func simulateUserClearedLoginData() {
        ui.userTextField.type("")
        ui.passwordTextField.type("")
    }
    
    var isLoading: Bool {
        loginLoadingViewController?.isLoading == true
    }
    
    var canSendRequest: Bool {
        loginLoadingViewController?.canSendRequest == true &&
        loginLoadingViewController?.loginButton.isUserInteractionEnabled == true
    }
    
    var loginError: String? {
        errorViewController?.error
    }
}

private extension UITextField {
    
    func type(_ text: String) {
        self.text = text
        send(event: .editingChanged)
    }
    
}
