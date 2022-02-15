//
//  LoadResourcePresentationAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import SharedPresentation
import TVShowsiOS
import TVShows
import Combine

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView, RequestMaker: LoaderMaker> {
    public var presenter: LoadResourcePresenter<Resource, View>?
    private var cancellable: AnyCancellable?
    private let loader: () -> AnyPublisher<Resource, Error>
    private var loaderMaker: RequestMaker
    private var isLoading = false
    
    public init(
        loader: @escaping () -> AnyPublisher<Resource, Error>,
        loaderMaker: RequestMaker
    ) {
        self.loader = loader
        self.loaderMaker = loaderMaker
    }
    
    private func load() {
        guard !isLoading else { return }
        isLoading = true
        presenter?.didStartLoadingResource()
        cancellable = loader().sink { [weak self] completion in
            self?.isLoading = false
            if case let .failure(error) = completion {
                self?.presenter?.didFinishLoading(with: error)
            }
        } receiveValue: { [weak self] resource in
            self?.isLoading = false
            self?.presenter?.didFinishLoading(with: resource)
        }
    }
    
    private func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}

extension LoadResourcePresentationAdapter: HomeRefreshControllerDelegate where Resource == [TVShow] {
    public func loadShows() {
        load()
    }
}

extension LoadResourcePresentationAdapter: TVShowCellControllerDelegate where Resource == Data {
    public func requestImage() {
        load()
    }
    
    public func cancelDownload() {
        cancel()
    }
}

extension LoadResourcePresentationAdapter: HomeHeaderControllerDelegate
where Resource == [TVShow], RequestMaker.RequestType == ShowsRequest {
    
    public var selectedIndex: Int {
        switch loaderMaker.requestType {
        case .popular:
            return 0
        case .topRated:
            return 1
        case .onTV:
            return 2
        case .airingToday:
            return 3
        }
    }
    
    public func requestOnTVShows() {
        loaderMaker.requestType = .onTV
        load()
    }
    
    public func requestAiringTodayShows() {
        loaderMaker.requestType = .airingToday
        load()
    }
    
    public func requestPopularShows() {
        loaderMaker.requestType = .popular
        load()
    }
    
    public func requestTopRatedShows() {
        loaderMaker.requestType = .topRated
        load()
    }
}
