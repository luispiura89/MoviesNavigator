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
    public let expirationDate: Date
}

public final class CodableTokenStore {
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    private struct CodableStoredToken: Codable {
        let token: String
        let expirationDate: Date
    }
    
    public typealias FetchTokenResult = Result<String, Error>
    public typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    public typealias StoreTokenResult = Result<Void, Error>
    public typealias StoreTokenCompletion = (StoreTokenResult) -> Void
    
    public func fetch(completion: @escaping FetchTokenCompletion) {
        guard let storedTokenData = try? Data(contentsOf: storeURL) else {
            return completion(.failure(TokenStoreError.emptyStore))
        }
        completion(
            Result {
                let storedToken = try JSONDecoder().decode(CodableStoredToken.self, from: storedTokenData)
                return storedToken.token
            }.mapError { _ in
                TokenStoreError.writeOperationFailed
            }
        )
    }
    
    public func store(_ token: StoredToken, completion: @escaping StoreTokenCompletion) {
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
                TokenStoreError.writeOperationFailed
            }
        )
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
    
    func test_store_deliversEmptyTokenErrorWhenThereIsNoStoredToken() {
        let sut = makeSUT(withURL: storeURL())
        
        expectStoredToken(in: sut, toBeEqualsTo: nil)
    }
    
    func test_store_deliversEmptyTokenErrorWhenTokenStoreOperationFailed() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: cachesDirectory())
        
        store(token: StoredToken(token: "any-token", expirationDate: Date()), in: instanceToWrite)
        
        expectStoredToken(in: instanceToRead, toBeEqualsTo: nil)
    }
    
    func test_store_deliversStoredTokenWhenThereIsAStoredToken() {
        let instanceToRead = makeSUT(withURL: storeURL())
        let instanceToWrite = makeSUT(withURL: storeURL())
        let token = StoredToken(token: "any-token", expirationDate: Date())
        
        store(token: token, in: instanceToWrite)
        
        expectStoredToken(in: instanceToRead, toBeEqualsTo: token.token)
    }
    
    // MARK: - Helpers
    
    private func clearSideEffects() {
        try? FileManager.default.removeItem(at: storeURL())
    }
    
    private func makeSUT(withURL url: URL) -> CodableTokenStore {
        return CodableTokenStore(storeURL: url)
    }
    
    private func cachesDirectory() -> URL {
        FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
    }
    
    private func storeURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
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
