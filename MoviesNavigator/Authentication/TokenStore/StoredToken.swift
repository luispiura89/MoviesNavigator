//
//  StoredToken.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import Foundation

public struct StoredToken {
    public let token: String
    public let expirationDate: Date
    
    public init(token: String, expirationDate: Date) {
        self.token = token
        self.expirationDate = expirationDate
    }
}
