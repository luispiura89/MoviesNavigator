//
//  TVShowCellController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit
import TVShows

public final class TVShowCellController: NSObject, UICollectionViewDataSource {
    
    private let viewModel: TVShowViewModel
    
    public init(viewModel: TVShowViewModel) {
        self.viewModel = viewModel
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        collectionView.dequeueReusableCell(withReuseIdentifier: TVShowHomeCell.dequeueIdentifier, for: indexPath) as! TVShowHomeCell
        
        cell.nameLabel.text = viewModel.name
        cell.dateLabel.text = viewModel.firstAirDate
        cell.voteAverageLabel.text = viewModel.voteAverage
        cell.overviewLabel.text = viewModel.overview
        
        return cell
    }
}
