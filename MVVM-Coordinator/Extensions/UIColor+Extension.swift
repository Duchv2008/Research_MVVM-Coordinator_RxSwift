//
//  UIColor+Extension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(red: UInt, green: UInt, blue: UInt) {
        self.init(red: CGFloat(Float(red)/255.0),
                  green: CGFloat(Float(green)/255.0),
                  blue: CGFloat(Float(blue)/255.0), alpha: 1.0)
    }

    public convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = alpha

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
