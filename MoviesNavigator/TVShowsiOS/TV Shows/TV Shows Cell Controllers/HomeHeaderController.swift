//
//  HomeHeaderController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 22/12/21.
//

import UIKit

public protocol HomeHeaderControllerDelegate {
    var selectedIndex: Int { get }
    
    func requestPopularShows()
    func requestTopRatedShows()
    func requestOnTVShows()
    func requestAiringTodayShows()
}

public final class HomeHeaderController: NSObject, UICollectionViewDataSource {
    
    private var header: HomeHeader?
    private var delegate: HomeHeaderControllerDelegate?
    
    public init(delegate: HomeHeaderControllerDelegate?) {
        self.delegate = delegate
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: HomeHeader.viewKind, withReuseIdentifier: HomeHeader.reuseIdentifier, for: indexPath) as? HomeHeader
        header?.selectionSegment.selectedSegmentIndex = delegate?.selectedIndex ?? 0
        header?.loadPopularHandler = { [weak self] in self?.delegate?.requestPopularShows() }
        header?.loadTopRatedHandler = { [weak self] in self?.delegate?.requestTopRatedShows() }
        header?.loadOnTVHandler = { [weak self] in self?.delegate?.requestOnTVShows() }
        header?.loadAiringTodayHandler = { [weak self] in self?.delegate?.requestAiringTodayShows() }
        return header!
    }
}
