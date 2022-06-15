//
//  UIImage+TVShows.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 27/12/21.
//

import UIKit

extension UIImage {
    public static var retryLoading: UIImage? {
        UIImage(named: "ReloadIcon", in: Bundle(for: TVShowCell.self), compatibleWith: nil)
    }
}
