//
//  LoginSnapshotTests.swift
//  AuthenticationiOSTests
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import AuthenticationiOS
import XCTest

final class LoginSnapshotTests: XCTestCase {
    
    func test_login_shouldRender() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LOGIN_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LOGIN_dark")
    }
    
    func test_login_shouldLoad() {
        let sut = makeSUT()
        
        sut.startLoading()

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LOGIN_LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LOGIN_LOADING_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LoginViewController {
        let sut = LoginViewController()
        sut.loadViewIfNeeded()
        return sut
    }
}

private extension LoginViewController {
    
    func startLoading() {
        loginLoadingViewController.isLoading = true
    }
    
}
