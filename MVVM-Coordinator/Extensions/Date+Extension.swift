//
//  Date+Extension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import Foundation

extension Date {
    public func toString(format: String = "yyyy/MM/dd") -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = Locale.current
        return dateFormater.string(from: self)
    }
}
