//
//  File.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import SVProgressHUD

class IndicatorCustomView: UIView {
    let svIndicator = SVProgressHUD()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let size: CGFloat = 100.0
        let frameOfIndicator = CGRect(x: (frame.width - size)/2, y: (frame.height - size)/2, width: size, height: size)
        svIndicator.frame = frameOfIndicator

        let blurView = UIView(frame: frame)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(blurView)
        addSubview(svIndicator)
        backgroundColor = .clear
    }

    func isShow(_ isLoading: Bool) {
        if isLoading {
            let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
            rootView?.addSubview(self)
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
            removeFromSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
