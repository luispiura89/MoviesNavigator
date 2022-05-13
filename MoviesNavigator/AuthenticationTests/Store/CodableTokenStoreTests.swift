//
//  CodableTokenStore.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import XCTest
import Authentication

final class CodableTokenStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        clearSideEffects()
    }
    
    override func tearDown() {
        super.tearDown()
        clearSideEffects()
    }
    
    func test_fetch_deliversEmptyTokenErrorWhenThereIsNoStoredToken() {
        let sut = makeSUT(withURL: storeURL())
        
        expectStoredToken(in: sut, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversOperationErrorWhenFetchingInvalidData() {
        let sut = makeSUT(withURL: storeURL())
        
        try! Data("Any data".utf8).write(to: storeURL())
        
        expectStoredToken(in: sut, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversEmptyTokenErrorWhenTokenStoreOperationFailed() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: cachesDirectory())
        
        store(token: StoredToken(token: "any-token", expirationDate: Date()), in: instanceToWrite)
        
        expectStoredToken(in: instanceToRead, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversStoredTokenWhenThereIsAStoredToken() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        let token = StoredToken(token: "any-token", expirationDate: Date())
        
        store(token: token, in: instanceToWrite)
        
        expectStoredToken(in: instanceToRead, toBeEqualsTo: token.token)
    }
    
    func test_fetch_deliversEmptyTokenErrorAfterTokenDeletion() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        let instanceToDelete = makeSUT(withURL: storeURL())
        let token = StoredToken(token: "any-token", expirationDate: Date())
        
        store(token: token, in: instanceToWrite)
        expectStoredToken(in: instanceToRead, toBeEqualsTo: token.token)
        delete(from: instanceToDelete)
        expectStoredToken(in: instanceToRead, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversPreviouslyStoredTokenAfterTokenDeletionError() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        let instanceToDelete = makeSUT(withURL: invalidURL())
        let token = StoredToken(token: "any-token", expirationDate: Date())

        store(token: token, in: instanceToWrite)
        expectStoredToken(in: instanceToRead, toBeEqualsTo: token.token)
        delete(from: instanceToDelete)
        expectStoredToken(in: instanceToRead, toBeEqualsTo: token.token)
    }
    
    func test_store_sideEffectsRunSerially() {
        let sut = makeSUT(withURL: storeURL())
        let exp1 = expectation(description: "Read expectation")
        let exp2 = expectation(description: "Store expectation")
        let exp3 = expectation(description: "Delete expectation")
        
        sut.fetch { _ in
            exp1.fulfill()
        }
        sut.store(StoredToken(token: "any-token", expirationDate: Date())) { _ in
            exp2.fulfill()
        }
        sut.deleteToken { _ in
            exp3.fulfill()
        }
        
        wait(for: [exp1, exp2, exp3], timeout: 8.0, enforceOrder: true)
    }
    
    // MARK: - Helpers
    
    private func clearSideEffects() {
        try? FileManager.default.removeItem(at: storeURL())
    }
    
    private func makeSUT(withURL url: URL) -> TokenStore {
        return CodableTokenStore(storeURL: url)
    }
    
    private func cachesDirectory() -> URL {
        FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
    }
    
    private func invalidURL() -> URL {
        URL(fileURLWithPath: "\(cachesDirectory().path)_invalidURL")
    }
    
    private func storeURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func expectStoredToken(
        in store: TokenStore,
        toBeEqualsTo token: String?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for token fetch")
        var fetchedToken: String?
        store.fetch { result in
            fetchedToken = try? result.get().token
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(fetchedToken, token, file: file, line: line)
    }
    
    private func store(token: StoredToken, in instanceToWrite: TokenStore) {
        let exp = expectation(description: "Wait for token store")
        instanceToWrite.store(token) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func delete(from instanceToDelete: TokenStore) {
        let exp = expectation(description: "Wait for token deletion")
        instanceToDelete.deleteToken { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
}
