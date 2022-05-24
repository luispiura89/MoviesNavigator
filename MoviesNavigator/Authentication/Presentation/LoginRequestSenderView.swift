//
//  LoginRequestSenderView.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 24/5/22.
//

import Foundation

public protocol LoginRequestSenderView {
    func update(_ viewModel: LoginRequestSenderViewModel)
}

public struct LoginRequestSenderViewModel {
    public let isEnabled: Bool
    
    public init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
}
