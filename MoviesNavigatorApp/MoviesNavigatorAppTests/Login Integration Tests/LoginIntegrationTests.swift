//
//  LoginIntegrationTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 23/5/22.
//

import XCTest
import AuthenticationiOS
import Authentication
import SharedPresentation
import SharediOS
import MoviesNavigatorApp
import Combine

typealias LoginPresentationAdapter = LoadResourcePresentationAdapter<SessionToken, LoginViewAdapter, LoginMaker>

final class LoginUIComposer {
    
    static func compose() -> LoginViewController {
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

extension LoadResourcePresentationAdapter: LoginLoadingViewControllerDelegate where Resource == SessionToken {
    
    public func sendLoginRequest() {
        load()
    }
    
}

final class LoginViewAdapter: ResourceView {
    
    func update(_ viewModel: ResourceViewModel<SessionToken>) {}
    
}

final class LoginMaker: LoaderMaker {
    var requestType: Any? = nil
    
    func makeRequest() -> AnyPublisher<SessionToken, Error> {
        PassthroughSubject<SessionToken, Error>().eraseToAnyPublisher()
    }
}

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

final class LoginIntegrationTests: XCTestCase {
    
    func test_login_shouldHandleLoginButtonStatus() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.canSendRequest, false, "Login should not be able to send a request before user filled data")
        sut.simulateUserFilledLoginData()
        XCTAssertEqual(sut.canSendRequest, true, "Login should be able to send a request after user filled data")
        sut.simulateUserClearedLoginData()
        XCTAssertEqual(sut.canSendRequest, false, "Login should not be able to send a request before after user erased data")
    }
    
    func test_login_shouldHandleLoadingStatus() {
        let sut = makeSUT()
        
        sut.simulateUserFilledLoginData()
        XCTAssertEqual(sut.isLoading, false, "Login should not send request on fill operations")
        sut.simulateUserSentLoginRequest()
        XCTAssertEqual(sut.isLoading, true, "Login should be able to send a request after user filled data")
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> LoginViewController {
        let controller = LoginUIComposer.compose()
        controller.loadViewIfNeeded()
        
        trackMemoryLeaks(controller, file: file, line: line)
        
        return controller
    }
    
}

private extension LoginViewController {
    
    func simulateUserSentLoginRequest() {
        loginLoadingViewController?.loginButton.send(event: .touchUpInside)
    }
    
    func simulateUserFilledLoginData() {
        ui.userTextField.type("any-user")
        ui.passwordTextField.type("any-password")
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
}

private extension UITextField {
    
    func type(_ text: String) {
        self.text = text
        send(event: .editingChanged)
    }
    
}
