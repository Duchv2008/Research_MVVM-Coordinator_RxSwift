//
//  UIApplication+Extension.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/7/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }

    func openLink(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey: Any](), completionHandler: nil)
        }
    }
}

extension UIWindow {
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        let previousViewController = rootViewController
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
        rootViewController = newRootViewController
    }
}
