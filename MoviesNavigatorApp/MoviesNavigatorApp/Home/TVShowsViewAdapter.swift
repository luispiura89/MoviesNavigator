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
import UIKit

public final class TVShowViewAdapter: ResourceView {
    
    private weak var controller: HomeViewController?
    private let posterLoader: (URL) -> LoadShowPosterPublisher
    
    public init(controller: HomeViewController, posterLoader: @escaping (URL) -> LoadShowPosterPublisher) {
        self.controller = controller
        self.posterLoader = posterLoader
    }
    
    public func update(_ viewModel: ResourceViewModel<[TVShow]>) {
        let (viewModels, loaders) = makeLoadersAndModels(from: viewModel.resource)
        controller?.setCellControllers(
            controllers: viewModels.map { viewModel in
                guard let loader = loaders[viewModel] else {
                    return nil
                }
                
                let presentationAdapter = LoadResourcePresentationAdapter<Data, HomeCellViewAdapter>(loader: { loader })
                let cell = TVShowCellController(viewModel: viewModel, delegate: presentationAdapter)
                let adapter = HomeCellViewAdapter(cell: cell)
                presentationAdapter.presenter = LoadResourcePresenter<Data, HomeCellViewAdapter>(
                    loadingView: adapter,
                    errorView: adapter,
                    resourceView: adapter,
                    resourceMapper: UIImage.init)
                return cell
            }.compactMap { $0 }
        )
    }
    
    private func makeLoadersAndModels(from shows: [TVShow]) -> (viewModels: [TVShowViewModel], loaders: [TVShowViewModel: LoadShowPosterPublisher]) {
        var loaders = [TVShowViewModel: LoadShowPosterPublisher]()
        let viewModels: [TVShowViewModel] = shows.map { [weak self] model in
            let viewModel = TVShowPresenter.map([model])
            viewModel.first.map {
                if let url = model.posterPath {
                    loaders[$0] = self?.posterLoader(url)
                }
            }
            return viewModel.first
        }.compactMap { $0 }
        return (viewModels, loaders)
    }
}
