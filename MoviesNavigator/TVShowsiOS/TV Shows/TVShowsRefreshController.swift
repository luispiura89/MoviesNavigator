//
//  TVShowsRefreshController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 12/1/22.
//

import Foundation
import UIKit
import SharedPresentation

public protocol TVShowsRefreshControllerDelegate {
    func loadShows()
}

public final class TVShowsRefreshController: LoadingView {
    
    public private(set) var isLoading: Bool {
        set { newValue ? refreshView.beginRefreshing() : refreshView.endRefreshing() }
        get { refreshView.isRefreshing }
    }
    
    lazy var refreshView: UIRefreshControl = {
        let refreshView = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshView.tintColor = .clear
        refreshView.addTarget(self, action: #selector(loadShows), for: .valueChanged)
        return refreshView
    }()
    
    private var delegate: TVShowsRefreshControllerDelegate?
    
    public init(delegate: TVShowsRefreshControllerDelegate?) {
        self.delegate = delegate
    }
    
    @objc func loadShows() {
        refreshView.beginRefreshing()
        delegate?.loadShows()
    }
    
    public func update(_ viewModel: LoadingViewModel) {
        isLoading = viewModel.isLoading
    }
}
