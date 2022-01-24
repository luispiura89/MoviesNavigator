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
    func cancelDownload()
}

public final class TVShowCellController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let viewModel: TVShowViewModel
    private var cell: TVShowHomeCell?
    private let delegate: TVShowCellControllerDelegate?
    
    private enum State: Equatable {
        case loading
        case failed
        case completed(UIImage?)
        case none
    }
    
    private var state: State = .none
    
    public init(viewModel: TVShowViewModel, delegate: TVShowCellControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cell == nil {
            state = .none
            cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TVShowHomeCell.dequeueIdentifier, for: indexPath) as? TVShowHomeCell)
            cell?.retryActionHandler = { [weak self] in
                self?.retryDownload()
            }
        }
        
        cell?.nameLabel.text = viewModel.name
        cell?.dateLabel.text = viewModel.firstAirDate
        cell?.voteAverageLabel.text = viewModel.voteAverage
        cell?.overviewLabel.text = viewModel.overview
        state == .loading ? startLoadingAnimation() : stopLoadingAnimation()
        state == .failed ? enableRetryAction() : disableRetryAction()
        downloadImageIfNeeded()
        
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.cell = nil
        delegate?.cancelDownload()
    }
    
    public func setPosterImage(_ image: UIImage?) {
        cell?.posterImageView.image = image
        cell?.retryLoadingButton.isHidden = true
        cell?.loadingView.stopAnimating()
        state = .completed(image)
    }
    
    public func setLoadingErrorState() {
        cell?.posterImageView.image = nil
        enableRetryAction()
        cell?.loadingView.stopAnimating()
        state = .failed
    }
    
    public func setLoadingState() {
        startLoadingAnimation()
        state = .loading
    }
    
    private func startLoadingAnimation() {
        cell?.loadingView.startAnimating()
    }
    
    private func stopLoadingAnimation() {
        cell?.loadingView.stopAnimating()
    }
    
    private func enableRetryAction() {
        cell?.retryLoadingButton.isHidden = false
    }
    
    private func disableRetryAction() {
        cell?.retryLoadingButton.isHidden = true
    }
    
    private func retryDownload() {
        state = .none
        delegate?.requestImage()
    }
    
    private func downloadImageIfNeeded() {
        switch state {
        case .completed(let loadedImage):
            cell?.posterImageView.image = loadedImage
        case .failed: break
        default:
            delegate?.requestImage()
        }
    }
}
