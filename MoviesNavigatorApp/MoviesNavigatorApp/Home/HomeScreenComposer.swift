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

public enum ShowsRequest {
    case popular
    case topRated
    case onTV
    case airingToday
}

public final class HomeScreenComposer {

    typealias LoadShowsPresentationAdapter = LoadResourcePresentationAdapter<[TVShow], TVShowViewAdapter, ShowsLoaderMaker>
    
    public static func composeWith(
        loader: @escaping (ShowsRequest) -> LoadShowsPublisher,
        posterLoader: @escaping (URL) -> LoadShowPosterPublisher
    ) -> HomeViewController {
        let loaderMaker = ShowsLoaderMaker(loader: loader)
        let presentationAdapter = LoadShowsPresentationAdapter(loader: loaderMaker.makeRequest, loaderMaker: loaderMaker)
        let loadShowsController = HomeRefreshController(delegate: presentationAdapter)
        let controller = HomeViewController(loadController: loadShowsController)
        controller.setHeaders(headers: [HomeHeaderController(delegate: presentationAdapter)])
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

public final class ShowsLoaderMaker: LoaderMaker {
    
    private let loader: (ShowsRequest) -> LoadShowsPublisher
    
    init(loader: @escaping (ShowsRequest) -> LoadShowsPublisher) {
        self.loader = loader
    }
    
    public var requestType: ShowsRequest = .popular
    
    public func makeRequest() -> LoadShowsPublisher {
        loader(requestType).dispatchOnMainQueue()
    }
    
}
