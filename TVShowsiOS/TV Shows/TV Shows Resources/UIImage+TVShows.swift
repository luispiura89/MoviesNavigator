//
//  UIImage+TVShows.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 27/12/21.
//

import UIKit

extension UIImage {
    static var retryLoading: UIImage? {
        UIImage(named: "ReloadIcon", in: Bundle(for: TVShowsViewController.self), compatibleWith: nil)
    }
}
