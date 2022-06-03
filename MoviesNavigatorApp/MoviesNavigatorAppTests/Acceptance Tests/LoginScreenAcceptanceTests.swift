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
        let (sut, store) = launch()

        XCTAssertTrue(sut.rootViewController is HomeViewController)
        XCTAssertEqual(store.storedToken.count, 1)
    }
    
    private func launch() -> (MockWindow, TokenStoreStub) {
        let store = TokenStoreStub.emptyTokenStore
        let delegate = SceneDelegate(httpClient: StubHTTPClient.online, store: store)
        let window = MockWindow()
        delegate.window = window
        delegate.configure()
        
        let loginView = window.rootViewController as! LoginViewController
        loginView.simulateUserFilledLoginData()
        loginView.simulateUserSentLoginRequest()
        
        return (window, store)
    }
    
}
