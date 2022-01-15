//
//  TVShowsViewAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import SharedPresentation
import TVShowsiOS
import TVShows

public final class TVShowViewAdapter: ResourceView {
    
    private weak var controller: HomeViewController?
    
    public init(controller: HomeViewController) {
        self.controller = controller
    }
    
    public func update(_ viewModel: ResourceViewModel<[TVShowViewModel]>) {
        controller?.setCellControllers(
            controllers: viewModel.resource.map {
                TVShowCellController(viewModel: $0, delegate: nil)
            }
        )
    }
}
