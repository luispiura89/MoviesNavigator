//
//  TVShowsRefreshController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 12/1/22.
//

import Foundation
import UIKit
import SharedPresentation

public protocol HomeRefreshControllerDelegate {
    func loadShows()
}

public final class HomeRefreshController: NSObject, LoadingView {
    
    public var isLoading: Bool {
        set { newValue ? refreshView.beginRefreshing() : refreshView.endRefreshing() }
        get { refreshView.isRefreshing }
    }
    
    public private(set) lazy var refreshView: UIRefreshControl = {
        let refreshView = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshView.tintColor = .white
        refreshView.addTarget(self, action: #selector(loadShows), for: .valueChanged)
        return refreshView
    }()
    
    private var delegate: HomeRefreshControllerDelegate?
    
    public init(delegate: HomeRefreshControllerDelegate?) {
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
