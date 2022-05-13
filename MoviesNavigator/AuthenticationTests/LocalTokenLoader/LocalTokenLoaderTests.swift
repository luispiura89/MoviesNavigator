//
//  LocalTokenLoaderTests.swift
//  AuthenticationTests
//
//  Created by Luis Francisco Piura Mejia on 13/5/22.
//

import XCTest
import Authentication

final class LocalTokenLoader {
    
    typealias FetchTokenResult = Result<String, Swift.Error>
    typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    enum Error: Swift.Error {
        case expiredToken
    }
    
    private let store: TokenStore
    
    init(store: TokenStore) {
        self.store = store
    }
    
    func fetchToken(currentDate: Date, completion: @escaping FetchTokenCompletion) {
        store.fetch { [store] result in
            guard
                let storedToken = try? result.get(),
                storedToken.expirationDate > currentDate else {
                    return store.deleteToken { _ in
                        completion(.failure(Error.expiredToken))
                    }
                }
            completion(.success(storedToken.token))
        }
    }
}

final class LocalTokenLoaderTests: XCTestCase {
    
    func test_fetchToken_retrievesTokenWhenTokenIsNotExpired() {
        let store = TokenStoreSpy()
        let sut = LocalTokenLoader(store: store)
        
        let fetchedToken = successfulFetchFor(sut, currentDate: Date().decreasing(minutes: 1)) {
            store.completeFetchSuccessfully()
        }
        
        XCTAssertEqual(fetchedToken, "any-token")
        XCTAssertEqual(store.fetchRequests.count, 1)
        XCTAssertEqual(store.deleteRequests.count, 0)
    }
    
    func test_fetchToken_deliversErrorOnExpiredTokenAndDeletesStoredToken() {
        let store = TokenStoreSpy()
        let sut = LocalTokenLoader(store: store)
        
        let error = errorFetchFor(sut, currentDate: Date()) {
            store.completeFetchWithExpiredToken()
            store.completeTokenDeletionSuccessfully()
        }
        
        XCTAssertEqual(error, LocalTokenLoader.Error.expiredToken)
        XCTAssertEqual(store.fetchRequests.count, 1)
        XCTAssertEqual(store.deleteRequests.count, 1)
    }
    
    // MARK: - Helpers
    
    private func errorFetchFor(
        _ sut: LocalTokenLoader, currentDate: Date,
        on action: @escaping () -> Void
    ) -> LocalTokenLoader.Error {
        let result = resultFor(sut, currentDate: currentDate, on: action)
        var receivedError: LocalTokenLoader.Error?
        if case let .failure(error as LocalTokenLoader.Error) = result {
            receivedError = error
        }
        return receivedError!
    }
    
    private func successfulFetchFor(
        _ sut: LocalTokenLoader, currentDate: Date,
        on action: @escaping () -> Void
    ) -> String {
        let result = resultFor(sut, currentDate: currentDate, on: action)
        var receivedToken: String?
        if case let .success(token) = result {
            receivedToken = token
        }
        return receivedToken!
    }
    
    private func resultFor(
        _ sut: LocalTokenLoader,
        currentDate: Date,
        on action: @escaping () -> Void
    ) -> LocalTokenLoader.FetchTokenResult {
        let exp = expectation(description: "Wait for token fetch")
        var receivedResult: LocalTokenLoader.FetchTokenResult?
        sut.fetchToken(currentDate: currentDate) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        return receivedResult!
    }
    
    private final class TokenStoreSpy: TokenStore {
        
        private(set) var fetchRequests = [FetchTokenCompletion]()
        private(set) var deleteRequests = [TokenOperationCompletion]()

        func fetch(completion: @escaping FetchTokenCompletion) {
            fetchRequests.append(completion)
        }
        
        func store(_ token: StoredToken, completion: @escaping TokenOperationCompletion) {
            
        }
        
        func deleteToken(completion: @escaping TokenOperationCompletion) {
            deleteRequests.append(completion)
        }
        
        func completeFetchSuccessfully(at index: Int = 0) {
            fetchRequests[index](.success(StoredToken(token: "any-token", expirationDate: Date())))
        }
        
        func completeFetchWithExpiredToken(at index: Int = 0) {
            fetchRequests[index](
                .success(
                    StoredToken(
                        token: "any-token",
                        expirationDate: Date().decreasing(hours: 1)
                    )
                )
            )
        }
        
        func completeTokenDeletionSuccessfully(at index: Int = 0) {
            deleteRequests[index](.success(()))
        }
    }
    
}

private extension Date {
    
    func decreasing(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: -hours, to: self)!
    }
    
    func decreasing(minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }
    
}
