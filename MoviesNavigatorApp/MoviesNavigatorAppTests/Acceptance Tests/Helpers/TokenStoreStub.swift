//
//  TokenStoreStub.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import Authentication

final class TokenStoreStub: SessionStore {
    
    private(set) var storedSessions = [StoredSession]()
    
    static var emptyTokenStore: TokenStoreStub {
        TokenStoreStub(fetchStub: .failure(TokenStoreError.emptyStore))
    }
    
    static var nonExpiredToken: TokenStoreStub {
        TokenStoreStub(fetchStub: .success(StoredSession(id: "any-id")))
    }
    
    private let fetchStub: SessionStore.FetchSessionResult
    
    init(fetchStub: SessionStore.FetchSessionResult) {
        self.fetchStub = fetchStub
    }
    
    func fetch(completion: @escaping FetchSessionCompletion) {
        completion(fetchStub)
    }
    
    func store(_ session: StoredSession, completion: @escaping SessionOperationCompletion) {
        storedSessions.append(session)
    }
    
    func deleteSession(completion: @escaping SessionOperationCompletion) {
        
    }
    
    
}
