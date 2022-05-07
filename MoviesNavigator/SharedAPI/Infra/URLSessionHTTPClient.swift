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
    
    public func get(from url: URL, completion: @escaping GetCompletion) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let urlResponse = response as? HTTPURLResponse  {
                    return (data, urlResponse)
                } else {
                    throw UnexpectedValuesError()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(task: task)
    }
    
    public func post(from url: URL, params: BodyParams, completion: @escaping PostCompletion) -> HTTPClientTask {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.addValue(.applicationJSON, forHTTPHeaderField: .contentType)
        
        let task = session.dataTask(with: request) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let urlResponse = response as? HTTPURLResponse  {
                    return (data, urlResponse)
                } else {
                    throw UnexpectedValuesError()
                }
            })
        }
        task.resume()
        return URLSessionTaskWrapper(task: task)
    }
}

final public class URLSessionTaskWrapper: HTTPClientTask {
    
    private let task: URLSessionDataTask
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    public func cancel() {
        task.cancel()
    }
}

private extension String {
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
}
