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
    private let loginPresentationAdapter: LoginPresentationAdapter
    private var isUserEmpty = true
    private var isPasswordEmpty = true
    
    init(
        loginRequestSenderPresenter: LoginRequestSenderPresenter,
        loginPresentationAdapter: LoginPresentationAdapter
    ) {
        self.loginRequestSenderPresenter = loginRequestSenderPresenter
        self.loginPresentationAdapter = loginPresentationAdapter
        updateLoginSenderViewState()
    }
    
    func update(user: String) {
        isUserEmpty = user.isEmpty
        loginPresentationAdapter.update(user: user)
        updateLoginSenderViewState()
    }
    
    func update(password: String) {
        isPasswordEmpty = password.isEmpty
        loginPresentationAdapter.update(password: password)
        updateLoginSenderViewState()
    }
    
    private func updateLoginSenderViewState() {
        !isUserEmpty && !isPasswordEmpty ?
        loginRequestSenderPresenter.enable() :
        loginRequestSenderPresenter.disable()
    }
}
