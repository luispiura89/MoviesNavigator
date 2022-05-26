//
//  LoadResourcePresentationAdapter+SendLoginRequest.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 26/5/22.
//

import AuthenticationiOS
import Authentication

extension LoadResourcePresentationAdapter: LoginLoadingViewControllerDelegate where Resource == SessionToken {
    
    public func sendLoginRequest() {
        load()
    }
    
}
