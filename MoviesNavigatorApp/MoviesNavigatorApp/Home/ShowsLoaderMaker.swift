//
//  ShowsLoaderMaker.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation

public final class ShowsLoaderMaker: LoaderMaker {
    
    private let loader: (ShowsRequest) -> LoadShowsPublisher
    
    init(loader: @escaping (ShowsRequest) -> LoadShowsPublisher) {
        self.loader = loader
    }
    
    public var requestType: ShowsRequest = .popular
    
    public func makeRequest() -> LoadShowsPublisher {
        loader(requestType).dispatchOnMainQueue()
    }
    
}
