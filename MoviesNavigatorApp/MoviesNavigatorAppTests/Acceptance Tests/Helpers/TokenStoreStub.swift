//
//  TokenStoreStub.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import Authentication

final class TokenStoreStub: TokenStore {
    
    static var emptyTokenStore: TokenStore {
        TokenStoreStub(fetchStub: .failure(TokenStoreError.emptyStore))
    }
    
    static var nonExpiredToken: TokenStore {
        TokenStoreStub(fetchStub: .success(StoredToken(token: "any-token", expirationDate: .distantFuture)))
    }
    
    static var expiredToken: TokenStore {
        TokenStoreStub(fetchStub: .success(StoredToken(token: "any-token", expirationDate: .distantPast)))
    }
    
    private let fetchStub: TokenStore.FetchTokenResult
    
    init(fetchStub: TokenStore.FetchTokenResult) {
        self.fetchStub = fetchStub
    }
    
    func fetch(completion: @escaping FetchTokenCompletion) {
        completion(fetchStub)
    }
    
    func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion) {
        
    }
    
    func deleteToken(completion: @escaping TokenOperationCompletion) {
        
    }
    
    
}
