//
//  HTTPClient.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import Foundation

public protocol HTTPClient {
    typealias GetResult = Result<(Data, HTTPURLResponse), Error>
    typealias GetCompletion = (GetResult) -> Void
    
    @discardableResult
    func get(from url: URL, completion: @escaping GetCompletion) -> HTTPClientTask
}

public protocol HTTPClientTask {
    func cancel()
}
