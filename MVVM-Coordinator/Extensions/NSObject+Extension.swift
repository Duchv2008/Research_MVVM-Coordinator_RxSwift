//
//  NSObject+Extension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import Foundation

extension NSObject {
    public class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }

    public var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
}
