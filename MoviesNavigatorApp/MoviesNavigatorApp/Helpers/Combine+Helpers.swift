//
//  Combine+Helpers.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/1/22.
//

import Foundation
import Combine
import SharedAPI
import Authentication

extension HTTPClient {
    
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func getPublisher(from url: URL) -> Publisher {
        var task: HTTPClientTask?
        return Deferred {
            Future { completion in
                task = get(from: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    func postPublisher(from url: URL, params: [String: Any]) -> Publisher {
        var task: HTTPClientTask?
        return Deferred {
            Future { completion in
                task = post(
                    from: url,
                    params: params,
                    completion: completion
                )
            }
        }
        .handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
}

extension LocalTokenLoader {
    
    typealias Publisher = AnyPublisher<String, Swift.Error>
    
    func fetchTokenPublisher() -> Publisher {
        Deferred {
            Future { completion in
                self.fetchToken(currentDate: Date(), completion: completion)
            }
        }
        .eraseToAnyPublisher()
        .dispatchOnMainQueue()
    }
    
}

private extension TokenStore {
    
    func storeIgnoringResult(_ session: StoredSession) {
        store(session) { _ in }
    }
    
}

extension AnyPublisher where Output == SessionToken {
    
    func saveToken(store: TokenStore) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { token in
            store.storeIgnoringResult(StoredSession(id: token.requestToken))
        })
        .eraseToAnyPublisher()
    }
    
    
    func validateToken(
        from url: URL,
        httpClient: HTTPClient,
        session: (user: String, password: String),
        endpoint: LoginEndpoint
    ) -> AnyPublisher<Output, Error> {
        mapError { $0 }
        .flatMap {
            httpClient.postPublisher(
                from: url,
                params: endpoint.getParameters(session.user, session.password, $0.requestToken)!
            )
        }
        .tryMap(NewTokenRequestMapper.map)
        .eraseToAnyPublisher()
    }
    
    func createSession(
        from url: URL,
        httpClient: HTTPClient,
        endpoint: LoginEndpoint
    ) -> AnyPublisher<RemoteSession, Error> {
        mapError { $0 }
        .flatMap {
            httpClient.postPublisher(
                from: url,
                params: endpoint.getParameters($0.requestToken)!
            )
        }
        .tryMap(CreateSessionMapper.map)
        .eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output == RemoteSession {
    
    func saveToken(store: TokenStore) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { session in
            store.storeIgnoringResult(StoredSession(id: session.id))
        })
        .eraseToAnyPublisher()
    }

}

extension AnyPublisher {
    public func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.sharedImmediateMainQueueScheduler)
            .eraseToAnyPublisher()
    }
    
    public func tryMapWithErasure<T>(mapper: @escaping (Output) throws -> T) -> AnyPublisher<T, Error> {
        tryMap(mapper)
            .eraseToAnyPublisher()
    }
}
