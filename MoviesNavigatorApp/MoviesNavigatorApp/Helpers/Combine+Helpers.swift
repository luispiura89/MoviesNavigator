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

extension AnyPublisher where Output == SessionToken {
    
    func saveToken(store: TokenStore) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { token in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            guard let date = formatter.date(from: token.expiresAt) else { return }
            store.store(StoredToken(token: token.requestToken, expirationDate: date)) { _ in}
        })
        .eraseToAnyPublisher()
    }
    
}

extension AnyPublisher {
    public func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.sharedImmediateMainQueueScheduler)
            .eraseToAnyPublisher()
    }
}
