//
//  LoadResourcePresentationAdapter.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import SharedPresentation
import TVShowsiOS
import Combine

public final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    public var presenter: LoadResourcePresenter<Resource, View>?
    private var cancellable: AnyCancellable?
    private let loader: () -> AnyPublisher<Resource, Error>
    
    public init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
}

extension LoadResourcePresentationAdapter: HomeRefreshControllerDelegate {
    public func loadShows() {
        presenter?.didStartLoadingResource()
        cancellable = loader().sink { [weak presenter] completion in
            if case let .failure(error) = completion {
                presenter?.didFinishLoading(with: error)
            }
        } receiveValue: { [weak presenter] resource in
            presenter?.didFinishLoading(with: resource)
        }

    }
}

extension LoadResourcePresentationAdapter: TVShowCellControllerDelegate {
    public func requestImage() {
        
    }
}
