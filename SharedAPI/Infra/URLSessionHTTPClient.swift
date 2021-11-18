//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by Luis Francisco Piura Mejia on 18/11/21.
//

import Foundation

final public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping GetCompletion) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
