//
//  LoginPresentationAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 27/5/22.
//

import SharedPresentation
import Authentication
import AuthenticationiOS
import Combine

typealias LoginPresenter = LoadResourcePresenter<RemoteSession, LoginViewAdapter>
public typealias LoginPublisherHandler = (String, String) -> AnyPublisher<RemoteSession, Error>

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
    
    func update(user: String) {
        self.user = user
    }
    
    func update(password: String) {
        self.password = password
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
