//
//  TVShowCellController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit
import TVShows

public protocol TVShowCellControllerDelegate {
    func requestImage()
}

public final class TVShowCellController: NSObject, UICollectionViewDataSource {
    
    private let viewModel: TVShowViewModel
    private var cell: TVShowHomeCell?
    private let delegate: TVShowCellControllerDelegate?
    private var loadedImage: UIImage?
    
    public init(viewModel: TVShowViewModel, delegate: TVShowCellControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cell == nil {
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TVShowHomeCell.dequeueIdentifier, for: indexPath) as? TVShowHomeCell)
        }
        
        cell?.nameLabel.text = viewModel.name
        cell?.dateLabel.text = viewModel.firstAirDate
        cell?.voteAverageLabel.text = viewModel.voteAverage
        cell?.overviewLabel.text = viewModel.overview
        if loadedImage == nil {
            delegate?.requestImage()
        } else {
            cell?.posterImageView.image = loadedImage
        }
        return cell!
    }
    
    public func setPosterImage(_ image: UIImage?) {
        loadedImage = image
        cell?.posterImageView.image = image
        cell?.retryLoadingButton.isHidden = true
        cell?.loadingView.stopAnimating()
    }
    
    public func setLoadingErrorState() {
        cell?.posterImageView.image = nil
        cell?.retryLoadingButton.isHidden = false
        cell?.loadingView.stopAnimating()
    }
    
    public func setLoadingState() {
        cell?.loadingView.startAnimating()
    }
}
