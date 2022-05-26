//
//  SessionToken.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 9/5/22.
//

import Foundation

public struct SessionToken {
    public let requestToken: String
    public let expiresAt: String
    
    public init(requestToken: String, expiresAt: String) {
        self.requestToken = requestToken
        self.expiresAt = expiresAt
    }
}
