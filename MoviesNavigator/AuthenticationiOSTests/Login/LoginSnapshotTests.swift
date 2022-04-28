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
        assert(snapshot: LoginViewController().snapshot(for: .iPhone13(style: .light)), named: "LOGIN_light")
        assert(snapshot: LoginViewController().snapshot(for: .iPhone13(style: .dark)), named: "LOGIN_dark")
    }
    
}
