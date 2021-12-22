//
//  HomeHeaderController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 22/12/21.
//

import UIKit

public final class HomeHeaderController: NSObject, UICollectionViewDataSource {
    
    private var header: HomeHeader?
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeader.reuseIdentifier, for: indexPath) as? HomeHeader
        header?.selectionSegment.selectedSegmentIndex = 0
        return header!
    }
}
