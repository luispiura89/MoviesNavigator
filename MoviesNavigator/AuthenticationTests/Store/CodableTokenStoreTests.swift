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
        let sut = CodableTokenStore()
        
        expectStoredToken(in: sut, toBeEqualsTo: nil)
    }
    
    func test_store_deliversEmptyTokenErrorWhenTokenStoreOperationFailed() {
        let instanceToRead = CodableTokenStore()
        let instanceToWrite = CodableTokenStore()
        
        store(token: StoredToken(token: "any-token", date: Date()), in: instanceToWrite)
        
        expectStoredToken(in: instanceToRead, toBeEqualsTo: nil)
    }
    
    // MARK: - Helpers
    
    private func expectStoredToken(
        in store: CodableTokenStore,
        toBeEqualsTo token: String?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for token fetch")
        var fetchedToken: String?
        store.fetch { result in
            fetchedToken = try? result.get()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(fetchedToken, token, file: file, line: line)
    }
    
    private func store(token: StoredToken, in instanceToWrite: CodableTokenStore) {
        let exp = expectation(description: "Wait for token store")
        instanceToWrite.store(token) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
}
