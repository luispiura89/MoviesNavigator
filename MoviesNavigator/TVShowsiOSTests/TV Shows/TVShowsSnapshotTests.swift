//
//  TVShowsSnapshotTests.swift
//  TVShowsiOSTests
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import XCTest
import TVShowsiOS
import TVShows
import SharedPresentation

final class TVShowsSnapshotTests: XCTestCase {

    func test_tvShows_loading() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "TV_SHOWS_LOADING_light")
    }
    
    func test_tvShows_withContent() {
        let sut = makeSUT()
        
        sut.setCellControllers(controllers: content())
        sut.loadShowsController?.isLoading = false
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "TV_SHOWS_WITH_CONTENT_light")
    }
    
    func test_tvShows_error() {
        let sut = makeSUT()
        
        sut.renderError()
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "TV_SHOWS_ERROR_light")
    }
    
    private func makeSUT() -> HomeViewController {
        let sut = HomeViewController(loadController: HomeRefreshController(delegate: nil))
        sut.loadViewIfNeeded()
        sut.setHeaders(headers: [HomeHeaderController()])
        return sut
    }
    
    private func content() -> [TVShowCellController] {
        let firstCellDelegate = ImageStub(color: .blue)
        let firstCell = TVShowCellController(viewModel:
                                                TVShowViewModel(
                                                    name: "A Show",
                                                    overview: "An Overview",
                                                    voteAverage: "5.0",
                                                    firstAirDate: "Jan 13, 2021"),
                                             delegate: firstCellDelegate)
        firstCellDelegate.controller = firstCell
        
        let secondCell = TVShowCellController(viewModel:
                                                TVShowViewModel(
                                                    name: "Another Show",
                                                    overview: "Another overview with a real long text that should break the line to see if the cell changes, and add more text to see the changes",
                                                    voteAverage: "6.0",
                                                    firstAirDate: "Jan 15, 2021"),
                                              delegate: nil)
        
        let thirdCellDelegate = ImageStub(color: .red)
        let thirdCell = TVShowCellController(viewModel:
                                                TVShowViewModel(
                                                    name: "Another Show with a very long title that should break the title line",
                                                    overview: "Another Overview",
                                                    voteAverage: "6.0",
                                                    firstAirDate: "Jan 15, 2021"),
                                             delegate: thirdCellDelegate)
        thirdCellDelegate.controller = thirdCell
        
        return [
            firstCell,
            secondCell,
            thirdCell
        ]
    }
}

private extension HomeViewController {
    func renderError() {
        update(ErrorViewModel(message: "An error occurred\nNext line"))
        loadShowsController?.isLoading = false
    }
}

private final class ImageStub: TVShowCellControllerDelegate {
    
    var controller: TVShowCellController?
    private let color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
    
    func requestImage() {
        if color == UIColor.red {
            controller?.setLoadingErrorState()
        } else {
            controller?.setPosterImage(UIImage.make(withColor: color))
        }
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
