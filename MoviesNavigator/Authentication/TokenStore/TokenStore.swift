//
//  TokenStore.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import Foundation

public protocol TokenStore {
    typealias FetchTokenResult = Result<StoredToken, Error>
    typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    typealias TokenOperationResult = Result<Void, Error>
    typealias TokenOperationCompletion = (TokenOperationResult) -> Void
    
    func fetch(completion: @escaping FetchTokenCompletion)
    func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion)
    func deleteToken(completion: @escaping TokenOperationCompletion)
}
