//
//  LoginScreenAcceptanceTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import XCTest
@testable import MoviesNavigatorApp
import AuthenticationiOS
import TVShowsiOS

final class LoginScreenAcceptanceTests: XCTestCase {
    
    func test_login_shouldNavigateToHomeAfterSuccessfulLogin() {
        let sut = launch()

        XCTAssertTrue(sut.rootViewController is HomeViewController)
    }
    
    private func launch() -> MockWindow {
        let delegate = SceneDelegate(httpClient: StubHTTPClient.online, store: TokenStoreStub.emptyTokenStore)
        let window = MockWindow()
        delegate.window = window
        delegate.configure()
        
        let loginView = window.rootViewController as! LoginViewController
        loginView.simulateUserFilledLoginData()
        loginView.simulateUserSentLoginRequest()
        
        return window
    }
    
}
