//
//  LoginRequestPresentationAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 26/5/22.
//

import AuthenticationiOS
import Authentication

final class LoginRequestSenderPresentationAdapter: LoginViewControllerDelegate {
    
    private let loginRequestSenderPresenter: LoginRequestSenderPresenter
    private var isUserEmpty = true
    private var isPasswordEmpty = true
    
    init(loginRequestSenderPresenter: LoginRequestSenderPresenter) {
        self.loginRequestSenderPresenter = loginRequestSenderPresenter
        updateLoginSenderViewState()
    }
    
    func update(user: String) {
        isUserEmpty = user.isEmpty
        updateLoginSenderViewState()
    }
    
    func update(password: String) {
        isPasswordEmpty = password.isEmpty
        updateLoginSenderViewState()
    }
    
    private func updateLoginSenderViewState() {
        !isUserEmpty && !isPasswordEmpty ?
        loginRequestSenderPresenter.enable() :
        loginRequestSenderPresenter.disable()
    }
}
