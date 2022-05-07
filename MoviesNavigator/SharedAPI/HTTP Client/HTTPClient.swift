//
//  HTTPClient.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import Foundation

public protocol HTTPClient {
    typealias GetResult = Result<(Data, HTTPURLResponse), Error>
    typealias PostResult = Result<(Data, HTTPURLResponse), Error>
    typealias GetCompletion = (GetResult) -> Void
    typealias PostCompletion = (PostResult) -> Void
    typealias BodyParams = [String: Any]
    
    @discardableResult
    func get(from url: URL, completion: @escaping GetCompletion) -> HTTPClientTask
    @discardableResult
    func post(from url: URL, params: BodyParams, completion: @escaping PostCompletion) -> HTTPClientTask
}

public protocol HTTPClientTask {
    func cancel()
}
