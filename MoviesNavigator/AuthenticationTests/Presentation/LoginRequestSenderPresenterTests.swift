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
    
    public func disable() {
        view.update(LoginRequestSenderViewModel(isEnabled: false))
    }
    
}

final class LoginRequestSenderPresenterTests: XCTestCase {
    
    func test_enable_enablesLoginview() {
        let (sut, view) = makeSUT()
        
        sut.enable()
        
        XCTAssertEqual(view.messages, [.enabled])
    }
    
    func test_disable_disablesLoginview() {
        let (sut, view) = makeSUT()
        
        sut.disable()
        
        XCTAssertEqual(view.messages, [.disabled])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (LoginRequestSenderPresenter, LoginRequestSenderViewSpy) {
        let view = LoginRequestSenderViewSpy()
        let sut = LoginRequestSenderPresenter(view: view)
        
        trackMemoryLeaks(sut, file: file, line: line)
        trackMemoryLeaks(view, file: file, line: line)
        
        return (sut, view)
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
