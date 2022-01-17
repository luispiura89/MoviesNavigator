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

public final class HomeScreenComposer {
    
    public typealias LoadShowsPublisher = AnyPublisher<[TVShow], Error>
    
    public static func composeWith(loader: @escaping () -> LoadShowsPublisher) -> HomeViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[TVShow], TVShowViewAdapter>(loader: loader)
        let loadShowsController = HomeRefreshController(delegate: presentationAdapter)
        let controller = HomeViewController(loadController: loadShowsController)
        controller.setHeaders(headers: [HomeHeaderController()])
        let viewAdapter = TVShowViewAdapter(controller: controller)
        let presenter = LoadResourcePresenter<[TVShow], TVShowViewAdapter>(
            loadingView: WeakReferenceProxy(instance: loadShowsController),
            errorView: WeakReferenceProxy(instance: controller),
            resourceView: viewAdapter,
            resourceMapper: TVShowPresenter.map
        )
        presentationAdapter.presenter = presenter
        return controller
    }
    
}
