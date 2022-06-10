//
//  UserInfoViewModel.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

public struct UserInfoViewModel {
    public let userName: String
    public let userHandle: String
    
    public init(userName: String, userHandle: String) {
        self.userName = userName
        self.userHandle = userHandle
    }
}
