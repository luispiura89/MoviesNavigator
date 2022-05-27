//
//  LoginIntegrationTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 23/5/22.
//

import XCTest
import AuthenticationiOS
import Authentication
import MoviesNavigatorApp
import Combine

final class LoginIntegrationTests: XCTestCase {
    
    func test_login_shouldHandleLoginButtonStatus() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.canSendRequest, false, "Login should not be able to send a request before user filled data")
        
        sut.simulateUserFilledLoginData()
        XCTAssertEqual(sut.canSendRequest, true, "Login should be able to send a request after user filled data")
        
        sut.simulateUserClearedLoginData()
        XCTAssertEqual(sut.canSendRequest, false, "Login should not be able to send a request after user erased data")
        
        sut.simulateUserFilledLoginData()
        XCTAssertEqual(sut.canSendRequest, true, "Login should not be able to send a request after user erased data for the second time")
    }
    
    func test_login_shouldHandleLoadingStatus() {
        let (sut, client) = makeSUT()
        
        sut.simulateUserFilledLoginData()
        XCTAssertEqual(sut.isLoading, false, "Login should not be loading before the user sent a request")
        
        sut.simulateUserSentLoginRequest()
        XCTAssertEqual(sut.isLoading, true, "Login should be loading after user sent request")
        
        client.completeLoginWithError()
        XCTAssertEqual(sut.isLoading, false, "Login should not be loading after failure")
        
        sut.simulateUserSentLoginRequest()
        XCTAssertEqual(sut.isLoading, true, "Login should be loading after user sent second request")
        
        client.completeLoginSuccessfully(at: 1)
        XCTAssertEqual(sut.isLoading, false, "Login should not be loading after successful request")
    }
    
    func test_login_shouldNotSendAnotherRequestUntilLoadingEnds() {
        let (sut, client) = makeSUT()
        
        sut.simulateUserFilledLoginData()
        sut.simulateUserSentLoginRequest()
        XCTAssertEqual(client.requests.count, 1, "Login sent request when there is no in progress loading")
        
        sut.simulateUserSentLoginRequest()
        XCTAssertEqual(client.requests.count, 1, "Login should not send another request before previous one completed")
        
        client.completeLoginWithError()
        sut.simulateUserSentLoginRequest()
        XCTAssertEqual(client.requests.count, 2, "Login should send another request after previous one completed")
    }
    
    func test_login_rendersErrorViewWhenLoginRequestFails() {
        let (sut, client) = makeSUT()
        
        XCTAssertNil(sut.loginError, "Login should not render error before sending a request")
        
        sut.simulateUserFilledLoginData()
        sut.simulateUserSentLoginRequest()
        client.completeLoginWithError()
        XCTAssertNotNil(sut.loginError, "Login should render error message after the request failed")
        
        sut.simulateUserSentLoginRequest()
        XCTAssertNil(sut.loginError, "Login should remove error view after sending a second request")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LoginViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let controller = LoginUIComposer.compose(loginPublisher: loaderSpy.loginPublisher(user:password:))
        controller.loadViewIfNeeded()
        
        trackMemoryLeaks(controller, file: file, line: line)
        trackMemoryLeaks(loaderSpy, file: file, line: line)
        
        return (controller, loaderSpy)
    }
    
    private final class LoaderSpy {
        
        private(set) var requests = [PassthroughSubject<SessionToken, Error>]()
        
        func completeLoginWithError(at index: Int = 0) {
            requests[index].send(
                completion: .failure(
                    NSError(
                        domain: "any error",
                        code: 0,
                        userInfo: nil
                    )
                )
            )
        }
        
        func completeLoginSuccessfully(at index: Int = 0) {
            requests[index].send(
                SessionToken(requestToken: "any-token", expiresAt: "")
            )
        }
        
        func loginPublisher(
            user: String,
            password: String
        ) -> AnyPublisher<SessionToken, Error> {
            let publisher = PassthroughSubject<SessionToken, Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
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
