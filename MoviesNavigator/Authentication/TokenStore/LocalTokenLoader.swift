//
//  LocalTokenLoader.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 16/5/22.
//

import Foundation

public final class LocalTokenLoader {
    
    public typealias FetchTokenResult = Result<String, Swift.Error>
    public typealias FetchTokenCompletion = (FetchTokenResult) -> Void
    
    public enum Error: Swift.Error {
        case expiredToken
    }
    
    private let store: TokenStore
    
    public init(store: TokenStore) {
        self.store = store
    }
    
    public func fetchToken(currentDate: Date, completion: @escaping FetchTokenCompletion) {
        store.fetch { [weak self] result in
            completion(
                Result {
                    let storedToken = try result.get()
                    guard storedToken.expirationDate > currentDate else {
                        throw Error.expiredToken
                    }
                    return storedToken.token
                }.mapError { _ in
                    self?.store.deleteIgnoringCompletion()
                    return Error.expiredToken
                }
            )
        }
    }
}

private extension TokenStore {
    func deleteIgnoringCompletion() {
        deleteToken { _ in }
    }
}
