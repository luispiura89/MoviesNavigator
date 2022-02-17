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
    var loaderMaker: RequestMaker
    private var isLoading = false
    
    public init(
        loader: @escaping () -> AnyPublisher<Resource, Error>,
        loaderMaker: RequestMaker
    ) {
        self.loader = loader
        self.loaderMaker = loaderMaker
    }
    
    func load() {
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
    
    func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
