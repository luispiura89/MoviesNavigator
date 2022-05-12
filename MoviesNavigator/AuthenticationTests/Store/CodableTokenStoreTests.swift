//
//  CodableTokenStore.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import XCTest

public enum TokenStoreError: Error {
    case emptyStore
}

public final class CodableTokenStore {
    
    public typealias FetchTokenResult = Result<String, Error>
    public typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    public func fetchToken(completion: @escaping FetchTokenCompletion) {
        completion(.failure(TokenStoreError.emptyStore))
    }
    
}

final class CodableTokenStoreTests: XCTestCase {
    
    func test_store_deliversEmptyTokenWhenThereIsNoStoredToken() {
        let instanceToRead = CodableTokenStore()
        
        let exp = expectation(description: "Wait for token fetch")
        var fetchedToken: String?
        instanceToRead.fetchToken { result in
            fetchedToken = try? result.get()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(fetchedToken, nil)
    }
    
}
