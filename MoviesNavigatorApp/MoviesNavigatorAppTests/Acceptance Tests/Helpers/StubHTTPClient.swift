//
//  StubHTTPClient.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 2/6/22.
//

import Foundation
import SharedAPI
import UIKit

final class StubHTTPClient: HTTPClient {
    
    private struct StubHTTPClientTask: HTTPClientTask {
        func cancel() {}
    }
    
    private var stub: (URL) -> HTTPRequestResult
    
    static var alwaysSucceed: StubHTTPClient { StubHTTPClient(stub: Self.makeSuccessfulResponse) }
    
    init(stub: @escaping (URL) -> HTTPRequestResult) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask {
        completion(stub(url))
        return StubHTTPClientTask()
    }

    func post(from url: URL, params: BodyParams, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask {
        completion(stub(url))
        return StubHTTPClientTask()
    }
    
    private static func makeSuccessfulResponse(for url: URL) -> HTTPRequestResult {
        .success(
            (
                Data("any data".utf8),
                .succesfulResponse
            )
        )
    }
}
