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
    
    func test_login_sendsLoginRequestWithProvidedData() {
        let (sut, client) = makeSUT()
        
        let firstTypedPassword = UUID().uuidString
        let firstTypedUser = UUID().uuidString
        assertSessionRequestSentWith(
            firstTypedUser,
            and: firstTypedPassword,
            to: client,
            from: sut
        )
        
        let secondTypedPassword = UUID().uuidString
        let secondTypedUser = UUID().uuidString
        assertSessionRequestSentWith(
            secondTypedUser,
            and: secondTypedPassword,
            to: client,
            from: sut,
            at: 1
        )
    }
    
    func test_login_shouldNotifyWhenLoginSucceed() {
        let exp = expectation(description: "Wait for login")
        let (sut, client) = makeSUT {
            exp.fulfill()
        }
        
        sut.simulateUserFilledLoginData()
        sut.simulateUserSentLoginRequest()
        client.completeLoginSuccessfully()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onSuccess: @escaping () -> Void = {},
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LoginViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let controller = LoginUIComposer.compose(
            loginPublisher: loaderSpy.loginPublisher,
            onSuccess: onSuccess
        )
        controller.loadViewIfNeeded()
        
        trackMemoryLeaks(controller, file: file, line: line)
        trackMemoryLeaks(loaderSpy, file: file, line: line)
        
        return (controller, loaderSpy)
    }
    
    private func assertSessionRequestSentWith(
        _ user: String,
        and password: String,
        to client: LoaderSpy,
        from sut: LoginViewController,
        at index: Int = 0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        sut.simulateUserFilledLoginData(user: user, password: password)
        sut.simulateUserSentLoginRequest()
        client.completeLoginSuccessfully()
        
        XCTAssertEqual(client.requests[index].session.user, user, file: file, line: line)
        XCTAssertEqual(client.requests[index].session.password, password, file: file, line: line)
    }
    
    private final class LoaderSpy {
        
        private(set) var requests = [
            (
                session: (user: String, password: String),
                subject: PassthroughSubject<RemoteSession, Error>
            )
        ]()
        
        func completeLoginWithError(at index: Int = 0) {
            requests[index].subject.send(
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
            requests[index].subject.send(
                RemoteSession(id: "any-id")
            )
        }
        
        func loginPublisher(
            user: String,
            password: String
        ) -> AnyPublisher<RemoteSession, Error> {
            let publisher = PassthroughSubject<RemoteSession, Error>()
            let session = (user, password)
            requests.append((session, publisher))
            return publisher.eraseToAnyPublisher()
        }
    }
}
