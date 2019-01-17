//
//  BasePopup.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import UIKit

public class BasePopup: UIView {

    @IBOutlet weak var containerView: UIView!

    var identifier: String {
        return ""
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }

    private func loadNib() {
        guard let content = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)?.first as? UIView else {
            return
        }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }

    public func showPopup(parentView: UIView? = nil) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        if parentView == nil {
            UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        } else {
            parentView?.addSubview(self)
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    public func closePopup() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        })
    }
}

