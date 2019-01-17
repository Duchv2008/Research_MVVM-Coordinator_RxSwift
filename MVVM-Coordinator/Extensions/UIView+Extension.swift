//
//  UIView+Extension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import UIKit

extension UIView {
    public func dropShadow(color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
                           radius: CGFloat = 2,
                           offset: CGSize = CGSize(width: 1, height: 2),
                           opacity: Float = 0.5) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius

        let rect = CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1)
        self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    public func rounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }

    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))

        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
