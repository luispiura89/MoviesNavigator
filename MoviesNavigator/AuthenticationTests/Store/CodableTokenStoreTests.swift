//
//  CodableTokenStore.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import XCTest

public enum TokenStoreError: Error {
    case emptyStore
    case writeOperationFailed
}

public struct StoredToken {
    public let token: String
    public let date: Date
}

public final class CodableTokenStore {
    
    public typealias FetchTokenResult = Result<String, Error>
    public typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    public typealias StoreTokenResult = Result<Void, Error>
    public typealias StoreTokenCompletion = (FetchTokenResult) -> Void
    
    public func fetch(completion: @escaping FetchTokenCompletion) {
        completion(.failure(TokenStoreError.emptyStore))
    }
    
    public func store(_ token: StoredToken, completion: @escaping StoreTokenCompletion) {
        completion(.failure(TokenStoreError.writeOperationFailed))
    }
    
}

final class CodableTokenStoreTests: XCTestCase {
    
    func test_store_deliversEmptyTokenErrorWhenThereIsNoStoredToken() {
        let instanceToRead = CodableTokenStore()
        
        let exp = expectation(description: "Wait for token fetch")
        var fetchedToken: String?
        instanceToRead.fetch { result in
            fetchedToken = try? result.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(fetchedToken, nil)
    }
    
    func test_store_deliversEmptyTokenErrorWhenTokenStoreOperationFailed() {
        let instanceToRead = CodableTokenStore()
        let instanceToWrite = CodableTokenStore()
        
        let exp1 = expectation(description: "Wait for token store")
        let token = StoredToken(token: "any-token", date: Date())
        instanceToWrite.store(token) { result in
            exp1.fulfill()
        }
        wait(for: [exp1], timeout: 1.0)
        
        let exp2 = expectation(description: "Wait for token fetch")
        var fetchedToken: String?
        instanceToRead.fetch { result in
            fetchedToken = try? result.get()
            exp2.fulfill()
        }
        wait(for: [exp2], timeout: 1.0)
        XCTAssertEqual(fetchedToken, nil)
    }
    
}
