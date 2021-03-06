//
//  TVShowCellController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

public protocol TVShowCellControllerDelegate {
    func requestImage()
    func cancelDownload()
}

public typealias TVShowCellViewModel = (name: String, overview: String, firstAirDate: String, voteAverage: String)

public final class TVShowCellController: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let viewModel: TVShowCellViewModel
    private var cell: TVShowCell?
    private let delegate: TVShowCellControllerDelegate?
    
    private enum State: Equatable {
        case loading
        case failed
        case completed(UIImage?)
        case none
    }
    
    private var state: State = .none
    
    public init(viewModel: TVShowCellViewModel, delegate: TVShowCellControllerDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = (collectionView.dequeueReusableCell(withReuseIdentifier: TVShowCell.dequeueIdentifier, for: indexPath) as? TVShowCell)
        cell?.retryActionHandler = { [weak self] in
            self?.retryDownload()
        }
        cell?.nameLabel.text = viewModel.name
        cell?.dateLabel.text = viewModel.firstAirDate
        cell?.voteAverageLabel.text = viewModel.voteAverage
        cell?.overviewLabel.text = viewModel.overview
        state == .loading ? startLoadingAnimation() : stopLoadingAnimation()
        state == .failed ? enableRetryAction() : disableRetryAction()
        cell?.posterImageView.image = nil
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
        cell?.retryLoadingButton.isHidden = true
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
