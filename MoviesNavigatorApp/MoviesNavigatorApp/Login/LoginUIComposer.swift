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
    
    public static func compose(loginPublisher: @escaping LoginPublisherHandler) -> LoginViewController {
        let loginPresentationAdapter = LoginPresentationAdapter(
            loginPublisher: loginPublisher
        )
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

typealias LoginPresenter = LoadResourcePresenter<SessionToken, LoginViewAdapter>
public typealias LoginPublisherHandler = (String, String) -> AnyPublisher<SessionToken, Error>

final class LoginPresentationAdapter: LoginLoadingViewControllerDelegate {
    
    var presenter: LoginPresenter?
    private let loginPublisher: LoginPublisherHandler
    private var user = ""
    private var password = ""
    private var cancellable: AnyCancellable?
    
    init(loginPublisher: @escaping LoginPublisherHandler) {
        self.loginPublisher = loginPublisher
    }
    
    func sendLoginRequest() {
        presenter?.didStartLoadingResource()
        cancellable = loginPublisher(user, password)
            .dispatchOnMainQueue()
            .sink { [weak presenter] completion in
                if case let .failure(error) = completion {
                    presenter?.didFinishLoading(with: error)
                }
            } receiveValue: { token in
                
            }
    }
    
}