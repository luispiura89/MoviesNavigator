//
//  LoadResourcePresentationAdapter+TVShowCellControllerDelegate.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 17/2/22.
//

import Foundation
import TVShowsiOS
import SharediOS

extension LoadResourcePresentationAdapter: TVShowCellControllerDelegate where Resource == Data {
    public func requestImage() {
        load()
    }
    
    public func cancelDownload() {
        cancel()
    }
}
