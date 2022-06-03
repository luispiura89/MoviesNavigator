//
//  TokenStoreStub.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import Authentication

final class TokenStoreStub: TokenStore {
    
    private(set) var storedToken = [StoredToken]()
    
    static var emptyTokenStore: TokenStoreStub {
        TokenStoreStub(fetchStub: .failure(TokenStoreError.emptyStore))
    }
    
    static var nonExpiredToken: TokenStoreStub {
        TokenStoreStub(fetchStub: .success(StoredToken(token: "any-token", expirationDate: .distantFuture)))
    }
    
    static var expiredToken: TokenStoreStub {
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
        storedToken.append(token)
    }
    
    func deleteToken(completion: @escaping TokenOperationCompletion) {
        
    }
    
    
}
