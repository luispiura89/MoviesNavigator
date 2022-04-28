//
//  UIColor+Authentication.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import UIKit

extension UIColor {
    static var blackBackground: UIColor {
        UIColor(named: "BlackBackground", in: Bundle(for: LoginViewController.self), compatibleWith: nil)!
    }
    static var primaryGreen: UIColor {
        UIColor(named: "PrimaryGreen", in: Bundle(for: LoginViewController.self), compatibleWith: nil)!
    }
}
