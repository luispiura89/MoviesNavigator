//
//  UIColor+TVShows.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

extension UIColor {
    static var blackBackground: UIColor {
        UIColor(named: "BlackBackground", in: Bundle(for: TVShowsViewController.self), compatibleWith: nil)!
    }
    static var tVShowCellBackground: UIColor {
        UIColor(named: "TVShowCellBackground", in: Bundle(for: TVShowsViewController.self), compatibleWith: nil)!
    }
    static var tVShowCellTextColor: UIColor {
        UIColor(named: "TVShowCellTextColor", in: Bundle(for: TVShowsViewController.self), compatibleWith: nil)!
    }
}
