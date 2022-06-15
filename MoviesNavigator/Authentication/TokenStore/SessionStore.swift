//
//  TokenStore.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import Foundation

public protocol SessionStore {
    typealias FetchSessionResult = Result<StoredSession, Error>
    typealias FetchSessionCompletion = (FetchSessionResult) -> Void
    
    typealias SessionOperationResult = Result<Void, Error>
    typealias SessionOperationCompletion = (SessionOperationResult) -> Void
    
    func fetch(completion: @escaping FetchSessionCompletion)
    func store(_ session: StoredSession, completion: @escaping SessionOperationCompletion)
    func deleteSession(completion: @escaping SessionOperationCompletion)
}
