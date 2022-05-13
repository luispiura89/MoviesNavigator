//
//  LocalTokenLoaderTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 13/5/22.
//

import XCTest
import Authentication

final class LocalTokenLoader {
    
    typealias FetchTokenResult = Result<String, Error>
    typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    private let store: TokenStore
    
    init(store: TokenStore) {
        self.store = store
    }
    
    func fetchToken(completion: @escaping FetchTokenCompletion) {
        store.fetch { result in
            completion(.success(try! result.get().token))
        }
    }
}

final class LocalTokenLoaderTests: XCTestCase {
    
    func test_loader_retrievesTokenWhenTokenIsNotExpired() {
        let store = TokenStoreSpy()
        let sut = LocalTokenLoader(store: store)
        
        let exp = expectation(description: "Wait for token fetch")
        sut.fetchToken { result in
            XCTAssertEqual(try? result.get(), "any-token")
            exp.fulfill()
        }
        store.completeFetchSuccessfully()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private final class TokenStoreSpy: TokenStore {
        
        private(set) var fetchRequests = [FetchTokenCompletion]()

        func fetch(completion: @escaping FetchTokenCompletion) {
            fetchRequests.append(completion)
        }
        
        func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion) {
            
        }
        
        func deleteToken(completion: @escaping TokenOperationCompletion) {
            
        }
        
        func completeFetchSuccessfully(at index: Int = 0) {
            fetchRequests[index](.success(StoredToken(token: "any-token", expirationDate: Date())))
        }
        
    }
    
}
