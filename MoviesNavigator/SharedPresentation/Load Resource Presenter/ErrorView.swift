//
//  ErrorView.swift
//  SharedPresentation
//
//  Created by Luis Francisco Piura Mejia on 10/1/22.
//

import Foundation

public struct ErrorViewModel {
    
    public static let emptyError = ErrorViewModel(message: nil)
    
    public let message: String?
    
    public init(message: String?) {
        self.message = message
    }
}

public protocol ErrorView {
    func update(_ viewModel: ErrorViewModel)
}
