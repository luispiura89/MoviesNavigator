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
    
    private struct CodableStoredSession: Codable {
        let id: String
    }
    
    public func fetch(completion: @escaping FetchTokenCompletion) {
        queueOperation { [storeURL] in
            guard let storedSessionData = try? Data(contentsOf: storeURL) else {
                return completion(.failure(TokenStoreError.emptyStore))
            }
            completion(
                Result {
                    let codableStoredSession = try JSONDecoder().decode(CodableStoredSession.self, from: storedSessionData)
                    return StoredSession(id: codableStoredSession.id)
                }.mapError { _ in
                    TokenStoreError.operationFailed
                }
            )
        }
    }
    
    public func store(_ session: StoredSession, completion: @escaping TokenOperationCompletion) {
        queueOperation { [storeURL] in
            completion(
                Result{
                    let codableStoredSession = CodableStoredSession(id: session.id)
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(codableStoredSession)
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
