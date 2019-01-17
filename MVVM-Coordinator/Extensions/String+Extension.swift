//
//  String+Extension.swift
//  ExtensionLibrary
//
//  Created by ha.van.duc on 12/19/18.
//  Copyright © 2018 ha.van.duc. All rights reserved.
//

import Foundation

extension String {
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }

    public func toDate(format: String = "yyyy/MM/dd") -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        dateFormater.locale = Locale.current
        return dateFormater.date(from: self)
    }
}
