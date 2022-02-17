//
//  LoadResourcePresentationAdapter+HomeHeaderControllerDelegate.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation
import TVShowsiOS
import TVShows

extension LoadResourcePresentationAdapter: HomeHeaderControllerDelegate
where Resource == [TVShow], RequestMaker.RequestType == ShowsRequest {
    
    public var selectedIndex: Int {
        switch loaderMaker.requestType {
        case .popular:
            return 0
        case .topRated:
            return 1
        case .onTV:
            return 2
        case .airingToday:
            return 3
        }
    }
    
    public func requestOnTVShows() {
        loaderMaker.requestType = .onTV
        load()
    }
    
    public func requestAiringTodayShows() {
        loaderMaker.requestType = .airingToday
        load()
    }
    
    public func requestPopularShows() {
        loaderMaker.requestType = .popular
        load()
    }
    
    public func requestTopRatedShows() {
        loaderMaker.requestType = .topRated
        load()
    }
}
