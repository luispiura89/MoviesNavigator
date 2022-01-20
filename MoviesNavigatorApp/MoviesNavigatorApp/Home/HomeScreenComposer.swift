//
//  HomeScreenComposer.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import Combine
import TVShowsiOS
import TVShows
import SharedPresentation
import UIKit

public typealias LoadShowsPublisher = AnyPublisher<[TVShow], Error>
public typealias LoadShowPosterPublisher = AnyPublisher<Data, Error>

public final class HomeScreenComposer {

    public static func composeWith(
        loader: @escaping () -> LoadShowsPublisher,
        posterLoader: @escaping (URL) -> LoadShowPosterPublisher
    ) -> HomeViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[TVShow], TVShowViewAdapter>(loader: { loader().dispatchOnMainQueue() })
        let loadShowsController = HomeRefreshController(delegate: presentationAdapter)
        let controller = HomeViewController(loadController: loadShowsController)
        controller.setHeaders(headers: [HomeHeaderController()])
        let viewAdapter = TVShowViewAdapter(controller: controller, posterLoader: posterLoader)
        let presenter = LoadResourcePresenter<[TVShow], TVShowViewAdapter>(
            loadingView: WeakReferenceProxy(instance: loadShowsController),
            errorView: WeakReferenceProxy(instance: controller),
            resourceView: viewAdapter,
            resourceMapper: { shows in shows }
        )
        presentationAdapter.presenter = presenter
        return controller
    }
}

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
