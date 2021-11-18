//
//  HTTPClient.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import Foundation

public protocol HTTPClient {
    typealias GetResult = (Data, HTTPURLResponse)
    typealias GetCompletion = (GetResult) -> Void
    
    func get(from url: URL, completion: @escaping GetCompletion)
}
