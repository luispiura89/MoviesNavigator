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
    private let posterLoader: (URL) -> LoadShowPosterPublisher
    
    public init(controller: HomeViewController, posterLoader: @escaping (URL) -> LoadShowPosterPublisher) {
        self.controller = controller
        self.posterLoader = posterLoader
    }
    
    public func update(_ viewModel: ResourceViewModel<[TVShow]>) {
        var loaders = [TVShowViewModel: LoadShowPosterPublisher]()
        let viewModels: [TVShowViewModel] = viewModel.resource.map { [weak self] model in
            let viewModel = TVShowPresenter.map([model])
            viewModel.first.map {
                if let url = model.posterPath {
                    loaders[$0] = self?.posterLoader(url)
                }
            }
            return viewModel.first
        }.compactMap { $0 }
        controller?.setCellControllers(
            controllers: viewModels.map { viewModel in
                let delegate: TVShowCellControllerDelegate? = loaders[viewModel].map { loader in
                    let newLoader = { loader }
                    return LoadResourcePresentationAdapter<Data, HomeCellViewAdapter>(loader: newLoader)
                }
                return TVShowCellController(viewModel: viewModel, delegate: delegate)
            }
        )
    }
}
