//
//  LoaderMaker.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 1/2/22.
//

import Foundation
import Combine

public protocol LoaderMaker {
    associatedtype RequestType
    associatedtype RequestResource
    
    var requestType: RequestType { set get }
    
    func makeRequest() -> AnyPublisher<RequestResource, Error>
}
