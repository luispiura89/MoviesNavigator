//
//  EmptyFavoritesShowCellController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 16/6/22.
//

import UIKit

public final class EmptyFavoritesShowCellController: NSObject, UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: EmptyFavoriteShowsCell.identifier,
            for: indexPath
        )
    }
    
}
