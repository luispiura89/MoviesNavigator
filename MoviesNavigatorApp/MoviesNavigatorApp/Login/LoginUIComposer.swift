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
        let loginLoadingViewController = LoginLoadingViewController(
            delegate: loginPresentationAdapter
        )
        let errorView = HeaderErrorViewController()
        let loginView = LoginViewAdapter()
        let loginPresenter = LoadResourcePresenter<SessionToken, LoginViewAdapter>(
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
    private var inProgress = false
    
    init(loginPublisher: @escaping LoginPublisherHandler) {
        self.loginPublisher = loginPublisher
    }
    
    func sendLoginRequest() {
        guard !inProgress else { return }
        inProgress.toggle()
        presenter?.didStartLoadingResource()
        cancellable = loginPublisher(user, password)
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.presenter?.didFinishLoading(with: error)
                }
                self?.inProgress.toggle()
            } receiveValue: { [weak self] token in
                self?.presenter?.didFinishLoading(with: token)
                self?.inProgress.toggle()
            }
    }
    
}
