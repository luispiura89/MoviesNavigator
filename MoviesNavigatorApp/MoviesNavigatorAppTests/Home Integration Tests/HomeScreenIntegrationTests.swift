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
import MoviesNavigatorApp
import Combine

final class HomeScreenIntegrationTests: XCTestCase {
    
    func test_homeScreen_rendersTVShows() {
        let loaderSpy = LoaderSpy()
        let controller = makeSUT(loader: loaderSpy.loader)
        
        loaderSpy.completeLoading(with: makeModels())
        
        shouldRender(makeModels(), in: controller)
    }
    
    func test_homeScreen_shouldHandleRefreshControl() {
        let loaderSpy = LoaderSpy()
        let controller = makeSUT(loader: loaderSpy.loader)
        
        XCTAssertTrue(controller.isLoading, "Loading indicator should appear after loading")
        
        loaderSpy.completeLoading(with: makeModels(), at: 0)
        XCTAssertFalse(controller.isLoading, "Loading indicator should disappear after first request completes")
        
        controller.simulateUserInitiatedReload()
        XCTAssertTrue(controller.isLoading, "Loading indicator should appear after user initiated reload")
        
        loaderSpy.completeLoading(with: anyError(), at: 1)
        XCTAssertFalse(controller.isLoading, "Loading indicator should disappear after second request completes")
    }
    
    func test_homeScreen_showsLoadingIndicatorAfterLoadingFail() {
        let loaderSpy = LoaderSpy()
        let controller = makeSUT(loader: loaderSpy.loader)
        
        XCTAssertFalse(controller.isShowingError, "Should not show error message before failure")
        
        loaderSpy.completeLoading(with: anyError())
        
        XCTAssertTrue(controller.isShowingError, "Should show error after loading failure")
    }
    
    func test_homeScreen_dismissesErrorViewOnTap() {
        let loaderSpy = LoaderSpy()
        let controller = makeSUT(loader: loaderSpy.loader)
        
        loaderSpy.completeLoading(with: anyError())
        controller.simulateUserDismissedErrorView()
        
        XCTAssertFalse(controller.isShowingError, "Should not show error after user dismissal")
    }
    
    func test_homeScreen_shouldRenderPreviouslyLoadedShowsAfterError() {
        let loaderSpy = LoaderSpy()
        let controller = makeSUT(loader: loaderSpy.loader)
        
        loaderSpy.completeLoading(with: makeModels())
        shouldRender(makeModels(), in: controller)
        
        controller.simulateUserInitiatedReload()
        loaderSpy.completeLoading(with: anyError(), at: 1)
        shouldRender(makeModels(), in: controller)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loader: @escaping () -> AnyPublisher<[TVShow], Error>, file: StaticString = #filePath, line: UInt = #line) -> HomeViewController {
        let controller = HomeScreenComposer.composeWith(loader: loader)
        
        controller.loadViewIfNeeded()
        trackMemoryLeaks(controller, file: file, line: line)
        
        return controller
    }
    
    private func makeModels() -> [TVShow] {
        [
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
    }
    
    private final class LoaderSpy {
        
        private var publishers = [PassthroughSubject<[TVShow], Error>]()
        
        func loader() -> AnyPublisher<[TVShow], Error> {
            let subject = PassthroughSubject<[TVShow], Error>()
            publishers.append(subject)
            return subject.eraseToAnyPublisher()
        }
        
        func completeLoading(with shows: [TVShow], at index: Int = 0) {
            guard index < publishers.count else { return }
            publishers[index].send(shows)
        }
        
        func completeLoading(with error: Error, at index: Int = 0) {
            guard index < publishers.count else { return }
            publishers[index].send(completion: .failure(error))
        }
    }
    
    private func trackMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "\(String(describing: instance)) stills in memory", file: file, line: line)
        }
    }
    
    private func shouldRender(_ models: [TVShow], in controller: HomeViewController, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(controller.renderedCells(), models.count, "Expected to render \(models.count) cells", file: file, line: line)
        
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
    
    private func anyError() -> NSError {
        NSError(domain: "Error", code: 0, userInfo: nil)
    }
}

extension UIControl {
    func send(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach({ selector in
                (target as NSObject).perform(Selector(selector))
            })
        }
    }
}
