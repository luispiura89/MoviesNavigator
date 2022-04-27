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
        let (controller, loaderSpy) = makeSUT()
        
        loaderSpy.completeLoading(with: makeModels())
        shouldRender(makeModels(), in: controller)
        XCTAssertEqual(loaderSpy.requestedShowType, [.popular])
        XCTAssertEqual(controller.selectedTabOption, 0, "Should select Popular tab")
        
        controller.selectTapOption(at: 1)
        XCTAssertEqual(loaderSpy.requestedShowType, [.popular, .topRated])
        XCTAssertEqual(controller.selectedTabOption, 1, "Should select Top Rated tab")
        let topRatedModel = makeModel(name: "Show 2", overview: "", url: URL(string: "https://another-url.com")!)
        loaderSpy.completeLoading(with: [topRatedModel], at: 1)
        shouldRender([topRatedModel], in: controller)
        
        controller.selectTapOption(at: 2)
        XCTAssertEqual(loaderSpy.requestedShowType, [.popular, .topRated, .onTV])
        XCTAssertEqual(controller.selectedTabOption, 2, "Should select OnTV tab")
        let onTVModel = makeModel(name: "Show 3", url: URL(string: "https://another-url.com")!)
        loaderSpy.completeLoading(with: [onTVModel], at: 2)
        shouldRender([onTVModel], in: controller)
        
        controller.selectTapOption(at: 3)
        XCTAssertEqual(loaderSpy.requestedShowType, [.popular, .topRated, .onTV, .airingToday])
        XCTAssertEqual(controller.selectedTabOption, 3, "Should select Airing Today tab")
        let newModel = makeModel(name: "Show 4", url: URL(string: "https://another-url.com")!)
        loaderSpy.completeLoading(with: [newModel], at: 3)
        shouldRender([newModel], in: controller)
        
        controller.selectTapOption(at: 0)
        XCTAssertEqual(loaderSpy.requestedShowType, [.popular, .topRated, .onTV, .airingToday, .popular])
        XCTAssertEqual(controller.selectedTabOption, 0, "Should select Popular tab")
        loaderSpy.completeLoading(with: makeModels(), at: 4)
        shouldRender(makeModels(), in: controller)
    }
    
    func test_homeScreen_shouldHandleRefreshControl() {
        let (controller, loaderSpy) = makeSUT()
        
        XCTAssertTrue(controller.isLoading, "Loading indicator should appear after loading")
        
        loaderSpy.completeLoading(with: makeModels(), at: 0)
        XCTAssertFalse(controller.isLoading, "Loading indicator should disappear after first request completes")
        
        controller.simulateUserInitiatedReload()
        XCTAssertTrue(controller.isLoading, "Loading indicator should appear after user initiated reload")
        
        loaderSpy.completeLoading(with: anyError(), at: 1)
        XCTAssertFalse(controller.isLoading, "Loading indicator should disappear after second request completes")
        
        controller.selectTapOption(at: 1)
        XCTAssertTrue(controller.isLoading, "Should show loading indicator when user selects an option in the tab")
        loaderSpy.completeLoading(with: makeModels(), at: 2)
        XCTAssertFalse(controller.isLoading, "Should not show loading after the tab action completes")
        
        controller.selectTapOption(at: 0)
        XCTAssertTrue(controller.isLoading, "Should show loading indicator when user selects another option in the tab")
        loaderSpy.completeLoading(with: anyError(), at: 3)
        XCTAssertFalse(controller.isLoading, "Should not show loading after the second tab action completes")
    }
    
    func test_homeScreen_showsLoadingIndicatorAfterLoadingFail() {
        let (controller, loaderSpy) = makeSUT()
        
        XCTAssertFalse(controller.isShowingError, "Should not show error message before failure")
        
        loaderSpy.completeLoading(with: anyError())
        
        XCTAssertTrue(controller.isShowingError, "Should show error after loading failure")
    }
    
    func test_homeScreen_dismissesErrorViewOnTap() {
        let (controller, loaderSpy) = makeSUT()
        
        loaderSpy.completeLoading(with: anyError())
        controller.simulateUserDismissedErrorView()
        
        XCTAssertFalse(controller.isShowingError, "Should not show error after user dismissal")
    }
    
    func test_homeScreen_shouldRenderPreviouslyLoadedShowsAfterError() {
        let (controller, loaderSpy) = makeSUT()
        
        loaderSpy.completeLoading(with: makeModels())
        shouldRender(makeModels(), in: controller)
        
        controller.simulateUserInitiatedReload()
        loaderSpy.completeLoading(with: anyError(), at: 1)
        shouldRender(makeModels(), in: controller)
    }
    
    func test_homeScreen_shouldRenderTVShowsAfterError() {
        let (controller, loaderSpy) = makeSUT()
        
        loaderSpy.completeLoading(with: anyError(), at: 0)
        controller.simulateUserInitiatedReload()
        
        loaderSpy.completeLoading(with: makeModels(), at: 1)
        shouldRender(makeModels(), in: controller)
    }
    
    func test_homeScreen_removesErrorViewWhenLoadingStarts() {
        let (controller, loaderSpy) = makeSUT()
        
        loaderSpy.completeLoading(with: anyError())
        XCTAssertTrue(controller.isShowingError, "Should display error when loading fails")
        
        controller.simulateUserInitiatedReload()
        XCTAssertFalse(controller.isShowingError, "Should not display error when new loading starts")
    }
    
    func test_homeScreen_reactsToEventsSentFromBackgroundThreads() {
        let (_, loaderSpy) = makeSUT()
        let models = makeModels()
        
        let exp = expectation(description: "Wait for loading")
        DispatchQueue.global().async {
            loaderSpy.completeLoading(with: models)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_homeScreen_requestsImageDownloadWhenCellAppears() {
        let (controller, loaderSpy) = makeSUT()
        let model0 = makeModel(name: "Show 1", url: anyURL())
        let model1 = makeModel(name: "Show 2", url: URL(string: "https://another-url.com")!)
        let models = [model0, model1]
        
        XCTAssertTrue(loaderSpy.requestedURLs.isEmpty, "Requested URLs should be empty until a cell appears")
        loaderSpy.completeLoading(with: models, at: 0)
        
        controller.displayCell(at: 0)
        controller.displayCell(at: 0)
        XCTAssertEqual(loaderSpy.requestedURLs, [model0.posterPath], "Home Screen should request image download for first cell")
        
        controller.displayCell(at: 1)
        controller.displayCell(at: 1)
        XCTAssertEqual(loaderSpy.requestedURLs, [model0.posterPath, model1.posterPath], "Home Screen should request image download for second cell")
        
        loaderSpy.completeImageLoadingWithError(at: 1)
        controller.retryImageDownloadOnCell(at: 1)
        controller.retryImageDownloadOnCell(at: 1)
        XCTAssertEqual(loaderSpy.requestedURLs, [model0.posterPath, model1.posterPath, model1.posterPath], "Home Screen should request image download for second cell")
    }
    
    func test_homeScreen_handlesPosterStatusForCells() {
        let (controller, loaderSpy) = makeSUT()
        
        loaderSpy.completeLoading(with: makeModels(), at: 0)
        controller.displayCell(at: 0)
        XCTAssertTrue(controller.isLoadingImage(at: 0), "Should display loading indicator on first cell")
        loaderSpy.completeImageLoadingWithError(at: 0)
        XCTAssertNil(controller.imageDataOnCell(at: 0), "Should not display image for first cell")
        XCTAssertTrue(controller.isShowingRetryActionOnCell(at: 0), "Should display retry action for first cell")
        XCTAssertFalse(controller.isLoadingImage(at: 0), "Should not display loading indicator on first cell")
        
        controller.displayCell(at: 1)
        XCTAssertTrue(controller.isLoadingImage(at: 1), "Should display loading indicator on second cell")
        loaderSpy.completeImageLoading(with: UIImage.make(withColor: .blue).pngData()!, at: 1)
        XCTAssertEqual(controller.imageDataOnCell(at: 1), UIImage.make(withColor: .blue).pngData(), "Should display image for second cell")
        XCTAssertFalse(controller.isShowingRetryActionOnCell(at: 1), "Should not display retry action for second cell")
        XCTAssertFalse(controller.isLoadingImage(at: 1), "Should not display loading indicator on second cell")
    }
    
    func test_homeScreen_retriesFailedDownload() {
        let (controller, loaderSpy) = makeSUT()
        let model0 = makeModel(name: "Show 1", url: anyURL())
        let model1 = makeModel(name: "Show 2", url: URL(string: "https://another-url.com")!)
        let models = [model0, model1]
        loaderSpy.completeLoading(with: models, at: 0)
        controller.displayCell(at: 0)
        loaderSpy.completeImageLoadingWithError(at: 0)

        controller.retryImageDownloadOnCell(at: 0)
        
        XCTAssertTrue(controller.isLoadingImage(at: 0), "Should show load spinner on retry action")
        XCTAssertFalse(controller.isShowingRetryActionOnCell(at: 0), "Should not show retry action after retry is executed")
        XCTAssertEqual(loaderSpy.requestedURLs, [model0.posterPath, model0.posterPath], "Should send retry request")
    }
    
    func test_homeScreen_shouldNotUpdateImageAfterCellHasBenReused() {
        let (controller, loaderSpy) = makeSUT()
        let model = makeModel(name: "", url: anyURL())
        loaderSpy.completeLoading(with: [model])
        
        controller.prepareForReuseCell(at: 0)
        loaderSpy.completeImageLoading(with: UIImage.make(withColor: .red).pngData()!, at: 0)
        
        XCTAssertNil(controller.imageDataOnCell(at: 0), "Should not render downloaded image for already deallocated cell")
    }
    
    func test_homeScreen_shouldCancelLoadWhenCellIsNotOnScreenAnymore() {
        let (controller, loaderSpy) = makeSUT()
        let model0 = makeModel(name: "Show 1", url: anyURL())
        let model1 = makeModel(name: "Show 2", url: URL(string: "https://another-url.com")!)
        loaderSpy.completeLoading(with: [model0, model1])
        
        controller.prepareForReuseCell(at: 0)
        controller.prepareForReuseCell(at: 1)
        
        XCTAssertEqual(loaderSpy.cancelledURLs, [model0.posterPath, model1.posterPath])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (HomeViewController, LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let controller = HomeScreenComposer.composeWith(loader: loaderSpy.loader, posterLoader: loaderSpy.imageLoader)
        
        controller.loadViewIfNeeded()
        trackMemoryLeaks(controller, file: file, line: line)
        trackMemoryLeaks(loaderSpy, file: file, line: line)
        
        return (controller, loaderSpy)
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
    
    private func makeModel(name: String, overview: String = "Another Overview", url: URL) -> TVShow {
        TVShow(
            id: 0,
            name: name,
            overview: overview,
            voteAverage: 6.1,
            firstAirDate: "2021-02-14",
            posterPath: url)
    }
    
    private final class LoaderSpy {
        
        private var showsRequests = [PassthroughSubject<[TVShow], Error>]()
        private var imageRequests = [PassthroughSubject<Data, Error>]()
        private(set) var requestedURLs = [URL]()
        private(set) var cancelledURLs = [URL]()
        private(set) var requestedShowType = [ShowsRequest]()
        
        func loader(_ type: ShowsRequest) -> AnyPublisher<[TVShow], Error> {
            let subject = PassthroughSubject<[TVShow], Error>()
            requestedShowType.append(type)
            showsRequests.append(subject)
            return subject.eraseToAnyPublisher()
        }
        
        func imageLoader(from url: URL) -> AnyPublisher<Data, Error> {
            let subject = PassthroughSubject<Data, Error>()
            imageRequests.append(subject)
            return subject.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledURLs.append(url)
            }, receiveRequest:  { [weak self] _ in
                self?.requestedURLs.append(url)
            }).eraseToAnyPublisher()
        }
        
        func completeLoading(with shows: [TVShow], at index: Int = 0) {
            guard index < showsRequests.count else { return }
            showsRequests[index].send(shows)
        }
        
        func completeLoading(with error: Error, at index: Int = 0) {
            guard index < showsRequests.count else { return }
            showsRequests[index].send(completion: .failure(error))
        }
        
        func completeImageLoadingWithError(at index: Int) {
            guard imageRequests.count > index else { return }
            imageRequests[index].send(completion: .failure(NSError(domain: "Error", code: 0, userInfo: nil)))
        }
        
        func completeImageLoading(with data: Data, at index: Int) {
            guard imageRequests.count > index else { return }
            imageRequests[index].send(data)
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
