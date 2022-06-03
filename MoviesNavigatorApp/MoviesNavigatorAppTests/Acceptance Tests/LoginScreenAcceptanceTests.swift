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
import SharedAPI

final class LoginScreenAcceptanceTests: XCTestCase {
    
    func test_login_shouldNavigateToHomeAfterSuccessfulLogin() {
        let (sut, store) = launch()

        XCTAssertTrue(sut.rootViewController is HomeViewController)
        XCTAssertEqual(store.storedToken.count, 1)
    }
    
    private func launch() -> (MockWindow, TokenStoreStub) {
        let store = TokenStoreStub.emptyTokenStore
        let delegate = SceneDelegate(httpClient: StubHTTPClient(stub: makeSuccessfulLoginResponse), store: store)
        let window = MockWindow()
        delegate.window = window
        delegate.configure()
        
        let loginView = window.rootViewController as! LoginViewController
        loginView.simulateUserFilledLoginData()
        loginView.simulateUserSentLoginRequest()
        
        return (window, store)
    }
    
    private func makeSuccessfulLoginResponse(url: URL) -> HTTPClient.HTTPRequestResult {
        return .success(
            (
                try! successfulHTTPResponseData(expirationDate: .distantFuture),
                .succesfulResponse
            )
        )
    }
    
    private func successfulHTTPResponseData(expirationDate: Date) throws -> Data {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let json: [String: Any] = [
            "expires_at": "2022-05-10 00:07:44 UTC",
            "request_token": "any-token",
            "success": true
        ]
        return try JSONSerialization.data(withJSONObject: json)
    }
    
}
