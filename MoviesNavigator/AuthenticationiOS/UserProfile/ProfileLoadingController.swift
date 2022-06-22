//
//  ProfileLoadingController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 22/6/22.
//

import Foundation
import UIKit

public final class ProfileLoadingController: NSObject {
    
    public var isLoading: Bool {
        get { view.isRefreshing }
        set { newValue ? view.beginRefreshing() : view.endRefreshing() }
    }
    
    lazy var view: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        return refreshControl
    }()
    
}
