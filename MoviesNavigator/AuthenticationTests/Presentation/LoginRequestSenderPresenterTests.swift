//
//  LoginRequestSenderPresenterTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 24/5/22.
//

import Foundation
import XCTest
import Authentication

public final class LoginRequestSenderPresenter {
    
    private let view: LoginRequestSenderView
    
    init(view: LoginRequestSenderView) {
        self.view = view
    }
    
    public func enable() {
        view.update(LoginRequestSenderViewModel(isEnabled: true))
    }
    
}

final class LoginRequestSenderPresenterTests: XCTestCase {
    
    func test_enable_enablesLoginview() {
        let view = LoginRequestSenderViewSpy()
        let sut = LoginRequestSenderPresenter(view: view)
        
        sut.enable()
        
        XCTAssertEqual(view.messages, [.enabled])
    }

    final private class LoginRequestSenderViewSpy: LoginRequestSenderView {
        
        enum Message: Equatable {
            case enabled
            case disabled
        }
        
        private(set) var messages = [Message]()
        
        func update(_ viewModel: LoginRequestSenderViewModel) {
            messages.append(viewModel.isEnabled ? .enabled : .disabled)
        }
    }
}
