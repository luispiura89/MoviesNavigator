//
//  CodableTokenStore.swift
//  Authentication
//
//  Created by Luis Francisco Piura Mejia on 12/5/22.
//

import Foundation

public final class CodableTokenStore: TokenStore {
    
    private let storeURL: URL
    private let queue = DispatchQueue(label: "\(CodableTokenStore.self).queue", attributes: .concurrent)
    
    public init(storeURL: URL) {
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
