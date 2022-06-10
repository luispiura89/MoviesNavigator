//
//  UIImage+Authentication.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 10/6/22.
//

import UIKit

extension UIImage {
    static var reload: UIImage {
        UIImage(named: "ReloadIcon", in: Bundle(for: LoginViewController.self), compatibleWith: nil)!
    }
}
