//
//  CodableTokenStore.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import XCTest

public enum TokenStoreError: Error {
    case emptyStore
    case operationFailed
}

public struct StoredToken {
    public let token: String
    public let expirationDate: Date
}

public protocol TokenStore {
    
    typealias FetchTokenResult = Result<StoredToken, Error>
    typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    typealias TokenOperationResult = Result<Void, Error>
    typealias TokenOperationCompletion = (TokenOperationResult) -> Void
    
    func fetch(completion: @escaping FetchTokenCompletion)
    func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion)
    func deleteToken(completion: @escaping TokenOperationCompletion)
}

public final class CodableTokenStore: TokenStore {
    
    private let storeURL: URL
    private let queue = DispatchQueue(label: "\(CodableTokenStore.self).queue", attributes: .concurrent)
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    private struct CodableStoredToken: Codable {
        let token: String
        let expirationDate: Date
    }
    
    public func fetch(completion: @escaping FetchTokenCompletion) {
        queueOperation { [storeURL] in
            guard let storedTokenData = try? Data(contentsOf: storeURL) else {
                return completion(.failure(TokenStoreError.emptyStore))
            }
            completion(
                Result {
                    let codableStoredToken = try JSONDecoder().decode(CodableStoredToken.self, from: storedTokenData)
                    return StoredToken(
                        token: codableStoredToken.token,
                        expirationDate: codableStoredToken.expirationDate
                    )
                }.mapError { _ in
                    TokenStoreError.operationFailed
                }
            )
        }
    }
    
    public func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion) {
        queueOperation { [storeURL] in
            completion(
                Result{
                    let codableStoredToken = CodableStoredToken(
                        token: token.token,
                        expirationDate: token.expirationDate
                    )
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(codableStoredToken)
                    try data.write(to: storeURL)
                }.mapError { _ in
                    TokenStoreError.operationFailed
                }
            )
        }
    }
    
    public func deleteToken(completion: @escaping TokenOperationCompletion) {
        queueOperation { [storeURL] in
            completion(
                Result{
                    try FileManager.default.removeItem(at: storeURL)
                }.mapError { _ in
                    TokenStoreError.operationFailed
                }
            )
        }
    }
    
    private func queueOperation(_ task: @escaping () -> Void) {
        queue.async(flags: .barrier) {
            task()
        }
    }
}

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
