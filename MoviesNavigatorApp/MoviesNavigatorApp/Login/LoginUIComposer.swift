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
import Combine

public final class LoginUIComposer {
    
    public static func compose(
        loginPublisher: @escaping LoginPublisherHandler,
        onSuccess: @escaping () -> Void
    ) -> LoginViewController {
        let loginPresentationAdapter = LoginPresentationAdapter(
            loginPublisher: loginPublisher
        )
        let loginLoadingViewController = LoginLoadingViewController(
            delegate: loginPresentationAdapter
        )
        let errorView = HeaderErrorViewController()
        let loginView = LoginViewAdapter(onSuccess: onSuccess)
        let loginPresenter = LoadResourcePresenter<RemoteSession, LoginViewAdapter>(
            loadingView: WeakReferenceProxy<LoginLoadingViewController>(
                instance: loginLoadingViewController
            ),
            errorView: WeakReferenceProxy<HeaderErrorViewController>(
                instance: errorView
            ),
            resourceView: loginView,
            resourceMapper: { session in session }
        )
        loginPresentationAdapter.presenter = loginPresenter
        let loginRequestSenderPresenter = LoginRequestSenderPresenter(view: loginLoadingViewController)
        return LoginViewController(
            loginLoadingViewController: loginLoadingViewController,
            errorViewController: errorView,
            delegate: LoginRequestSenderPresentationAdapter(
                loginRequestSenderPresenter: loginRequestSenderPresenter,
                loginPresentationAdapter: loginPresentationAdapter
            )
        )
    }
}
