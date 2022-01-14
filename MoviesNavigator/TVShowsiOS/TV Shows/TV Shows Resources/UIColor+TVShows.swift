//
//  UIColor+TVShows.swift
//  TVShowsiOS
//
//  Created by Luis Francisco Piura Mejia on 16/12/21.
//

import UIKit

extension UIColor {
    static var blackBackground: UIColor {
        UIColor(named: "BlackBackground", in: Bundle(for: HomeViewController.self), compatibleWith: nil)!
    }
    static var tVShowCellBackground: UIColor {
        UIColor(named: "TVShowCellBackground", in: Bundle(for: HomeViewController.self), compatibleWith: nil)!
    }
    static var tVShowCellTextColor: UIColor {
        UIColor(named: "TVShowCellTextColor", in: Bundle(for: HomeViewController.self), compatibleWith: nil)!
    }
    static var homeSegmentBackground: UIColor {
        UIColor(named: "HomeSegmentBackground", in: Bundle(for: HomeViewController.self), compatibleWith: nil)!
    }
}
