//
//  UIControl+SendEvent.swift
//  MoviesNavigatorAppTests
//
//  Created by Luis Francisco Piura Mejia on 25/5/22.
//

import UIKit

extension UIControl {
    func send(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach({ selector in
                (target as NSObject).perform(Selector(selector))
            })
        }
    }
}
