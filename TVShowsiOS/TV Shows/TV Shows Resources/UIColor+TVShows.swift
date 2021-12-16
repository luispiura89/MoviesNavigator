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
}
