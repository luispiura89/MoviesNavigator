//
//  LoginUIComposer.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 26/5/22.
//

import SharedPresentation
import Authentication
import AuthenticationiOS
import SharediOS

typealias LoginPresentationAdapter = LoadResourcePresentationAdapter<SessionToken, LoginViewAdapter, LoginMaker>

public final class LoginUIComposer {
    
    public static func compose() -> LoginViewController {
        let loginMaker = LoginMaker()
        let loginPresentationAdapter = LoginPresentationAdapter(loader: loginMaker.makeRequest, loaderMaker: loginMaker)
        let loadingView = LoginLoadingViewController(delegate: loginPresentationAdapter)
        let errorView = HeaderErrorViewController()
        let loginView = LoginViewAdapter()
        let loginPresenter = LoadResourcePresenter<SessionToken, LoginViewAdapter>(
            loadingView: loadingView,
            errorView: errorView,
            resourceView: loginView,
            resourceMapper: { session in session }
        )
        loginPresentationAdapter.presenter = loginPresenter
        let loginRequestSenderPresenter = LoginRequestSenderPresenter(view: loadingView)
        return LoginViewController(
            loginLoadingViewController: loadingView,
            errorViewController: errorView,
            delegate: LoginRequestSenderPresentationAdapter(
                loginRequestSenderPresenter: loginRequestSenderPresenter
            )
        )
    }
    
}
