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
    
    private struct UnexpectedValuesError: Error {}
    
    public func get(from url: URL, completion: @escaping GetCompletion) {
        session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let urlResponse = response as? HTTPURLResponse  {
                    return (data, urlResponse)
                } else {
                    throw UnexpectedValuesError()
                }
            })
        }.resume()
    }
}
