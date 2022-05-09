//
//  HTTPClient.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPRequestResult = Result<(Data, HTTPURLResponse), Error>
    typealias HTTPRequestCompletion = (HTTPRequestResult) -> Void
    typealias BodyParams = [String: Any]
    
    @discardableResult
    func get(from url: URL, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask
    @discardableResult
    func post(from url: URL, params: BodyParams, completion: @escaping HTTPRequestCompletion) -> HTTPClientTask
}

public protocol HTTPClientTask {
    func cancel()
}
