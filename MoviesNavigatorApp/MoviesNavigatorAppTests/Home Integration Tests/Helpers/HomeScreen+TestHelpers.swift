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
    
    func displayCell(at index: Int) {
        cell(at: index)
    }
    
    func simulateUserInitiatedReload() {
        loadShowsController?.refreshView.send(event: .valueChanged)
    }
    
    func simulateUserDismissedErrorView() {
        errorView.send(event: .touchUpInside)
        RunLoop.main.run(until: Date())
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
