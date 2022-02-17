//
//  LoadResourcePresentationAdapter+TVShowCellControllerDelegate.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation
import TVShowsiOS

extension LoadResourcePresentationAdapter: TVShowCellControllerDelegate where Resource == Data {
    public func requestImage() {
        load()
    }
    
    public func cancelDownload() {
        cancel()
    }
}
