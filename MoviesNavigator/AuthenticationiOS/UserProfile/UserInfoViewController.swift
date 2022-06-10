//
//  UserInfoViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

import UIKit

public final class UserInfoViewController: NSObject, UICollectionViewDataSource {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        1
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UserInfoCell.identifier,
            for: indexPath
        ) as! UserInfoCell
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: UserInfoHeader.viewKind,
            withReuseIdentifier: UserInfoHeader.viewKind,
            for: indexPath
        )
    }
}
