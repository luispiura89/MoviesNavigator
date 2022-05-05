//
//  LoginViewController.swift
//  AuthenticationiOS
//
//  Created by Luis Francisco Piura Mejia on 27/4/22.
//

import UIKit

public final class LoginViewController: UIViewController {
    
    public private(set) var loginLoadingViewController = LoginLoadingViewController()
    private var ui = LoginView(frame: .zero)
    
    public override func loadView() {
        view = ui
        ui.addLoadingButton(loginLoadingViewController.view)
    }
    
}
