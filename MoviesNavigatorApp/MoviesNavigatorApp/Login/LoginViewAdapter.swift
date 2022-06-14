//
//  LoginViewAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 26/5/22.
//

import SharedPresentation
import Authentication

final class LoginViewAdapter: ResourceView {
    
    private let onSuccess: () -> Void
    
    init(onSuccess: @escaping () -> Void) {
        self.onSuccess = onSuccess
    }
    
    func update(_ viewModel: ResourceViewModel<RemoteSession>) {
        onSuccess()
    }
    
}
