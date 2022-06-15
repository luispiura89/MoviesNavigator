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
    
    func test_fetch_deliversEmptyTokenErrorWhenThereIsNoStoredSession() {
        let sut = makeSUT(withURL: storeURL())
        
        expectStoredSessionID(in: sut, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversOperationErrorWhenFetchingInvalidData() {
        let sut = makeSUT(withURL: storeURL())
        
        try! Data("Any data".utf8).write(to: storeURL())
        
        expectStoredSessionID(in: sut, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversEmptyTokenErrorWhenTokenStoreOperationFailed() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: cachesDirectory())
        
        storeSession(in: instanceToWrite)
        
        expectStoredSessionID(in: instanceToRead, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversStoredSessionWhenThereIsAStoredSession() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        
        storeSession(in: instanceToWrite)
        
        expectStoredSessionID(in: instanceToRead)
    }
    
    func test_fetch_deliversEmptyTokenErrorAfterTokenDeletion() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        let instanceToDelete = makeSUT(withURL: storeURL())
        
        storeSession(in: instanceToWrite)
        expectStoredSessionID(in: instanceToRead)
        delete(from: instanceToDelete)
        expectStoredSessionID(in: instanceToRead, toBeEqualsTo: nil)
    }
    
    func test_fetch_deliversPreviouslyStoredSessionAfterTokenDeletionError() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        let instanceToDelete = makeSUT(withURL: invalidURL())

        storeSession(in: instanceToWrite)
        expectStoredSessionID(in: instanceToRead)
        delete(from: instanceToDelete)
        expectStoredSessionID(in: instanceToRead)
    }
    
    func test_store_sideEffectsRunSerially() {
        let sut = makeSUT(withURL: storeURL())
        let exp1 = expectation(description: "Read expectation")
        let exp2 = expectation(description: "Store expectation")
        let exp3 = expectation(description: "Delete expectation")
        
        sut.fetch { _ in
            exp1.fulfill()
        }
        sut.store(StoredSession(id: "any-id")) { _ in
            exp2.fulfill()
        }
        sut.deleteSession { _ in
            exp3.fulfill()
        }
        
        wait(for: [exp1, exp2, exp3], timeout: 8.0, enforceOrder: true)
    }
    
    // MARK: - Helpers
    
    private func clearSideEffects() {
        try? FileManager.default.removeItem(at: storeURL())
    }
    
    private func makeSUT(withURL url: URL) -> SessionStore {
        return CodableSessionStore(storeURL: url)
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
    
    private func expectStoredSessionID(
        in store: SessionStore,
        toBeEqualsTo sessionId: String? = "any-id",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for token fetch")
        var fetchedToken: String?
        store.fetch { result in
            fetchedToken = try? result.get().id
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(fetchedToken, sessionId, file: file, line: line)
    }
    
    private func storeSession(in instanceToWrite: SessionStore) {
        let exp = expectation(description: "Wait for token store")
        instanceToWrite.store(StoredSession(id: "any-id")) { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func delete(from instanceToDelete: SessionStore) {
        let exp = expectation(description: "Wait for token deletion")
        instanceToDelete.deleteSession { result in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
}
