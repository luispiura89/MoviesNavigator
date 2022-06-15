//
//  TVShowsViewAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import SharedPresentation
import TVShowsiOS
import SharediOS
import TVShows
import UIKit

public final class TVShowViewAdapter: ResourceView {
    
    private weak var controller: HomeViewController?
    private let posterLoader: (URL) -> LoadShowPosterPublisher
    typealias LoadPosterPresentationAdapter = LoadResourcePresentationAdapter<Data, HomeCellViewAdapter, PosterLoaderMaker>
    
    public init(controller: HomeViewController, posterLoader: @escaping (URL) -> LoadShowPosterPublisher) {
        self.controller = controller
        self.posterLoader = posterLoader
    }
    
    public func update(_ viewModel: ResourceViewModel<[TVShow]>) {
        let (viewModels, loaders) = makeLoadersAndModels(from: viewModel.resource)
        controller?.setCellControllers(
            controllers: viewModels.map { [weak self] viewModel in
                guard let self = self, let url = loaders[viewModel] else {
                    return nil
                }
                let posterLoaderMaker = PosterLoaderMaker(loader: { self.posterLoader(url).dispatchOnMainQueue() })
                let presentationAdapter = LoadPosterPresentationAdapter(loader: posterLoaderMaker.makeRequest, loaderMaker: posterLoaderMaker)
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
    
    private func makeLoadersAndModels(from shows: [TVShow]) -> (viewModels: [TVShowViewModel], loaders: [TVShowViewModel: URL]) {
        var loaders = [TVShowViewModel: URL]()
        let viewModels: [TVShowViewModel] = shows.map { model in
            let viewModel = TVShowPresenter.map([model])
            viewModel.first.map {
                if let url = model.posterPath {
                    loaders[$0] = url
                }
            }
            return viewModel.first
        }.compactMap { $0 }
        return (viewModels, loaders)
    }
}
