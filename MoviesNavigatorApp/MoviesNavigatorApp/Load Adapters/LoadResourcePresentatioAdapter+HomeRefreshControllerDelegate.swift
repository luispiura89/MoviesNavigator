//
//  LoadResourcePresentatioAdapter+HomeRefreshControllerDelegate.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation
import TVShowsiOS
import TVShows

extension LoadResourcePresentationAdapter: HomeRefreshControllerDelegate where Resource == [TVShow] {
    public func loadShows() {
        load()
    }
}
