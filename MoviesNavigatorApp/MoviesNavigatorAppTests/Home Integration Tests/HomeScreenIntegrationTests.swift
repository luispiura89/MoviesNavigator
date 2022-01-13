//
//  HomeScreenIntegrationTests.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 12/1/22.
//

import Foundation
import XCTest
import TVShowsiOS
import TVShows
import SharedPresentation
import Combine

final class LoadingViewAdapter: LoadingView {
    func update(_ viewModel: LoadingViewModel) {}
}

final class ErrorViewAdapter: ErrorView {
    func update(_ viewModel: ErrorViewModel) {}
}

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    var presenter: LoadResourcePresenter<Resource, View>?
    private var cancellable: AnyCancellable?
    private let loader: () -> AnyPublisher<Resource, Error>
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
}

extension LoadResourcePresentationAdapter: TVShowsViewControllerDelegate {
    func loadShows() {
        presenter?.didStartLoadingResource()
        cancellable = loader().sink { _ in
        } receiveValue: { [weak presenter] resource in
            presenter?.didFinishLoading(with: resource)
        }

    }
}

extension LoadResourcePresentationAdapter: TVShowCellControllerDelegate {
    func requestImage() {
        
    }
}

final class TVShowViewAdapter: ResourceView {
    
    private weak var controller: TVShowsViewController?
    
    init(controller: TVShowsViewController) {
        self.controller = controller
    }
    
    func update(_ viewModel: ResourceViewModel<[TVShowViewModel]>) {
        controller?.setCellControllers(
            headers: [HomeHeaderController()],
            controllers: viewModel.resource.map {
                TVShowCellController(viewModel: $0, delegate: nil)
            }
        )
    }
}

final class HomeScreenComposer {
    
    typealias LoadShowsPublisher = AnyPublisher<[TVShow], Error>
    
    static func composeWith(loader: @escaping () -> LoadShowsPublisher) -> TVShowsViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[TVShow], TVShowViewAdapter>(loader: loader)
        let controller = TVShowsViewController(delegate: presentationAdapter)
        let viewAdapter = TVShowViewAdapter(controller: controller)
        let presenter = LoadResourcePresenter<[TVShow], TVShowViewAdapter>(
            loadingView: LoadingViewAdapter(),
            errorView: ErrorViewAdapter(),
            resourceView: viewAdapter,
            resourceMapper: TVShowPresenter.map
        )
        presentationAdapter.presenter = presenter
        return controller
    }
    
}

final class HomeScreenIntegrationTests: XCTestCase {
    
    func test_homeScreen_rendersTVShows() {
        let loaderSpy = LoaderSpy()
        let controller = makeSUT(loader: loaderSpy.loader)
        let models = [
            TVShow(
                id: 0,
                name: "A Show",
                overview: "An Overview",
                voteAverage: 5.0,
                firstAirDate: "2021-01-13",
                posterPath: anyURL()),
            TVShow(
                id: 0,
                name: "Another Show",
                overview: "Another Overview",
                voteAverage: 6.1,
                firstAirDate: "2021-02-14",
                posterPath: anyURL())
        ]
        
        loaderSpy.completeLoading(with: models)
        
        shouldRender(models, in: controller)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loader: @escaping () -> AnyPublisher<[TVShow], Error>, file: StaticString = #filePath, line: UInt = #line) -> TVShowsViewController {
        let controller = HomeScreenComposer.composeWith(loader: loader)
        
        controller.loadViewIfNeeded()
        trackMemoryLeaks(controller, file: file, line: line)
        
        return controller
    }
    
    private final class LoaderSpy {
        
        private var publishers = [PassthroughSubject<[TVShow], Error>]()
        
        func loader() -> AnyPublisher<[TVShow], Error> {
            let subject = PassthroughSubject<[TVShow], Error>()
            publishers.append(subject)
            return subject.eraseToAnyPublisher()
        }
        
        func completeLoading(with shows: [TVShow], at index: Int = 0) {
            publishers[index].send(shows)
        }
    }
    
    private func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) stills in memory", file: file, line: line)
        }
    }
    
    private func shouldRender(_ models: [TVShow], in controller: TVShowsViewController, file: StaticString = #filePath, line: UInt = #line) {
        
        TVShowPresenter.map(models).enumerated().forEach {
            XCTAssertEqual(controller.name(at: $0), $1.name, "Name at \($0) failed", file: file, line: line)
            XCTAssertEqual(controller.overview(at: $0), $1.overview, "Overview at \($0) failed", file: file, line: line)
            XCTAssertEqual(controller.firstAirDate(at: $0), $1.firstAirDate, "Date at \($0) failed", file: file, line: line)
            XCTAssertEqual(controller.voteAverage(at: $0), $1.voteAverage, "Vote average at \($0) failed", file: file, line: line)
        }
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
}

private extension TVShowsViewController {
    
    private var showsSection: Int { 0 }
    
    private func cell(at index: Int) -> TVShowHomeCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(row: index, section: showsSection)
        return ds?.collectionView(collectionView, cellForItemAt: index) as? TVShowHomeCell
    }
    
    func name(at index: Int) -> String? {
        cell(at: index)?.nameLabel.text
    }
    
    func overview(at index: Int) -> String? {
        cell(at: index)?.overviewLabel.text
    }
    
    func firstAirDate(at index: Int) -> String? {
        cell(at: index)?.dateLabel.text
    }
    
    func voteAverage(at index: Int) -> String? {
        cell(at: index)?.voteAverageLabel.text
    }
}