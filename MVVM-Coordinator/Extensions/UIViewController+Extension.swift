//
//  UIViewControllerExtension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    func showErrorAlert(_ message: String?, action: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .default) { _ in
            action?()
        }
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    func showProgress(onView: UIView? = nil) {
        DispatchQueue.main.async {
            let containerView = onView ?? (AppDelegate.shared?.window ?? self.view)
            SVProgressHUD.setContainerView(containerView)
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.setDefaultStyle(.light)
            SVProgressHUD.show()
        }
    }

    func hideProgress() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}


extension UIAlertController {
    public func show(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil) {
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: animated, completion: completion)
    }

    @discardableResult public func addAction(title: String, style: UIAlertAction.Style = .default,
                                             isEnabled: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.isEnabled = isEnabled
        addAction(action)
        return action
    }

    public convenience init(title: String, message: String? = nil,
                            defaultActionButtonTitle: String = "OK".localized, tintColor: UIColor? = nil) {
        self.init(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }

    public convenience init(title: String = "Error".localized,
                            error: Error,
                            defaultActionButtonTitle: String = "OK".localized,
                            preferredStyle: UIAlertController.Style = .alert, tintColor: UIColor? = nil) {
        self.init(title: title, message: error.localizedDescription, preferredStyle: preferredStyle)
        let defaultAction = UIAlertAction(title: defaultActionButtonTitle, style: .default, handler: nil)
        addAction(defaultAction)
        if let color = tintColor {
            view.tintColor = color
        }
    }
}
