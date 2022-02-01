//
//  HomeScreen+TestHelpers.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 14/1/22.
//

import Foundation
import TVShowsiOS

extension HomeViewController {
    
    private var showsSection: Int { 0 }
    
    var isLoading: Bool {
        loadShowsController?.isLoading == true
    }
    
    var isShowingError: Bool {
        errorView.error != nil
    }
    
    @discardableResult
    private func cell(at index: Int) -> TVShowHomeCell? {
        guard renderedCells() > index else { return nil }
        let ds = collectionView.dataSource
        let index = IndexPath(row: index, section: showsSection)
        return ds?.collectionView(collectionView, cellForItemAt: index) as? TVShowHomeCell
    }
    
    func isShowingRetryActionOnCell(at index: Int) -> Bool {
        let cell = cell(at: index)
        return cell?.retryLoadingButton.isHidden == false
    }
    
    func imageDataOnCell(at index: Int) -> Data? {
        let cell = cell(at: index)
        return cell?.posterImageView.image?.pngData()
    }
    
    func isLoadingImage(at index: Int) -> Bool {
        cell(at: index)?.loadingView.isAnimating == true
    }
    
    func retryImageDownloadOnCell(at index: Int) {
        cell(at: index)?.retryLoadingButton.send(event: .touchUpInside)
    }
    
    func prepareForReuseCell(at index: Int) {
        guard let cell = cell(at: index) else { return }
        let delegate = collectionView.delegate
        let index = IndexPath(row: index, section: showsSection)
        delegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: index)
    }
    
    @discardableResult
    func displayCell(at index: Int) -> TVShowHomeCell? {
        cell(at: index)
    }
    
    func simulateUserInitiatedReload() {
        loadShowsController?.refreshView.send(event: .valueChanged)
    }
    
    func simulateUserDismissedErrorView() {
        errorView.send(event: .touchUpInside)
        RunLoop.main.run(until: Date())
    }
    
    func selectTapOption(at index: Int) {
        let ds = collectionView.dataSource
        let headerIndex = IndexPath(row: 0, section: showsSection)
        let header = ds?.collectionView?(collectionView, viewForSupplementaryElementOfKind: HomeHeader.viewKind, at: headerIndex) as? HomeHeader
        header?.selectionSegment.selectedSegmentIndex = index
        header?.selectionSegment.send(event: .valueChanged)
    }
    
    func renderedCells() -> Int {
        let ds = collectionView.dataSource
        return ds?.collectionView(collectionView, numberOfItemsInSection: showsSection) ?? 0
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
