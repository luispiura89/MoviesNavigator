//
//  LoginRequestSenderPresenter.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 24/5/22.
//

import Foundation

public final class LoginRequestSenderPresenter {
    
    private let view: LoginRequestSenderView
    
    public init(view: LoginRequestSenderView) {
        self.view = view
    }
    
    public func enable() {
        view.update(LoginRequestSenderViewModel(isEnabled: true))
    }
    
    public func disable() {
        view.update(LoginRequestSenderViewModel(isEnabled: false))
    }
    
}
