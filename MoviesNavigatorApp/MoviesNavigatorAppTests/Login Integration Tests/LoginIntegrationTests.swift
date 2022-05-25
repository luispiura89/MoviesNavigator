//
//  LoginIntegrationTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 23/5/22.
//

import XCTest
import AuthenticationiOS
import Authentication
import SharediOS

final class LoginUIComposer {
    
    static func compose() -> LoginViewController {
        let loadingView = LoginLoadingViewController()
        let loginRequestSenderPresenter = LoginRequestSenderPresenter(view: loadingView)
        return LoginViewController(
            loginLoadingViewController: loadingView,
            errorViewController: HeaderErrorViewController(),
            delegate: LoginPresentationAdapter(
                loginRequestSenderPresenter: loginRequestSenderPresenter
            )
        )
    }
    
}

class LoginPresentationAdapter: LoginViewControllerDelegate {
    
    private let loginRequestSenderPresenter: LoginRequestSenderPresenter
    private var user = ""
    private var password = ""
    
    init(loginRequestSenderPresenter: LoginRequestSenderPresenter) {
        self.loginRequestSenderPresenter = loginRequestSenderPresenter
    }
    
    func update(user: String) {
        self.user = user
        updateLoginSenderViewState()
    }
    
    func update(password: String) {
        self.password = password
        updateLoginSenderViewState()
    }
    
    private func updateLoginSenderViewState() {
        !user.isEmpty && !password.isEmpty ?
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
        loginLoadingViewController?.canSendRequest == true
    }
}

private extension UITextField {
    
    func type(_ text: String) {
        self.text = text
        send(event: .editingChanged)
    }
    
}
