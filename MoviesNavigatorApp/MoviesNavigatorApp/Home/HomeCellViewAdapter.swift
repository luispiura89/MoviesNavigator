//
//  HomeCellViewAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 25/1/22.
//

import Foundation
import SharedPresentation
import TVShowsiOS
import SharediOS
import UIKit

final class HomeCellViewAdapter: ResourceView, ErrorView, LoadingView {
    
    private weak var cell: TVShowCellController?
    
    init(cell: TVShowCellController) {
        self.cell = cell
    }
    
    func update(_ viewModel: ErrorViewModel) {
        if viewModel.message != nil {
            cell?.setLoadingErrorState()
        }
    }
    
    func update(_ viewModel: ResourceViewModel<UIImage?>) {
        cell?.setPosterImage(viewModel.resource)
    }
    
    func update(_ viewModel: LoadingViewModel) {
        if viewModel.isLoading {
            cell?.setLoadingState()
        }
    }
}
