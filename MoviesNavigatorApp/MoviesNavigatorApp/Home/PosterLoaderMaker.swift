//
//  PosterLoaderMaker.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation

final class PosterLoaderMaker: LoaderMaker {
    
    var requestType: Any? = nil
    
    private let loader: () -> LoadShowPosterPublisher
    
    init(loader: @escaping () -> LoadShowPosterPublisher) {
        self.loader = loader
    }
    
    func makeRequest() -> LoadShowPosterPublisher {
        loader().dispatchOnMainQueue()
    }
}
