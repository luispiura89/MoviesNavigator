//
//  TVShowsRefreshController.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 12/1/22.
//

import Foundation
import UIKit

public protocol TVShowsRefreshControllerDelegate {
    func loadShows()
}

public final class TVShowsRefreshController {
    
    lazy var refreshView: UIRefreshControl = {
        let refreshView = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshView.tintColor = .clear
        return refreshView
    }()
    
    private var delegate: TVShowsRefreshControllerDelegate?
    
    public init(delegate: TVShowsRefreshControllerDelegate?) {
        self.delegate = delegate
    }
    
    func loadShows() {
        delegate?.loadShows()
    }
    
}
