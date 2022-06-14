//
//  TokenStoreStub.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import Authentication

final class TokenStoreStub: TokenStore {
    
    private(set) var storedSessions = [StoredSession]()
    
    static var emptyTokenStore: TokenStoreStub {
        TokenStoreStub(fetchStub: .failure(TokenStoreError.emptyStore))
    }
    
    static var nonExpiredToken: TokenStoreStub {
        TokenStoreStub(fetchStub: .success(StoredSession(id: "any-id")))
    }
    
    private let fetchStub: TokenStore.FetchTokenResult
    
    init(fetchStub: TokenStore.FetchTokenResult) {
        self.fetchStub = fetchStub
    }
    
    func fetch(completion: @escaping FetchTokenCompletion) {
        completion(fetchStub)
    }
    
    func store(_ session: StoredSession, completion: @escaping TokenOperationCompletion) {
        storedSessions.append(session)
    }
    
    func deleteToken(completion: @escaping TokenOperationCompletion) {
        
    }
    
    
}
