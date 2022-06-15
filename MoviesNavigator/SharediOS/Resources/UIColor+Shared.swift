//
//  UIColor+Shared.swift
//  SharediOS
//
//  Created by Luis Francisco Piura Mejia on 15/6/22.
//

import UIKit

extension UIColor {
    static var tVShowCellBackground: UIColor {
        UIColor(named: "TVShowCellBackground", in: Bundle(for: TVShowCell.self), compatibleWith: nil)!
    }
    static var tVShowCellTextColor: UIColor {
        UIColor(named: "TVShowCellTextColor", in: Bundle(for: TVShowCell.self), compatibleWith: nil)!
    }
}
