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

    public func momentFromNow() -> String {
        let timeInterval = self.timeIntervalSinceNow
        if (timeInterval >= 0) {
            return "Hours.Format.JustNow".localized
        }
        let second = -timeInterval
        if(second <= 44) {
            return "Hours.Format.JustNow".localized
        }
        //Minute
        if(second <= 89) {
            return "Hours.Format.AMinuteAgo".localized
        }
        let minute = Int(-timeInterval / 60)
        if(minute <= 44) {
            return String(format: "Hours.Format.MinutesAgo".localized, minute)
        }
        //Hour
        if(minute <= 89) {
            return "Hours.Format.AHourAgo".localized
        }
        let hour = Int(-timeInterval / 60 / 60)
        if(hour <= 21) {
            return String(format: "Hours.Format.HoursAgo".localized, hour)
        }
        //Day
        if(hour <= 35) {
            return "Hours.Format.ADayAgo".localized
        }
        let day = Int(-timeInterval / 60 / 60 / 24)
        if(day <= 25) {
            return String(format: "Hours.Format.DaysAgo".localized, day)
        }
        //Month
        if(day <= 45) {
            return "Hours.Format.AMonthAgo".localized
        }
        let month = Int(-timeInterval / 60 / 60 / 24 / 30)
        if(day <= 319) {
            return String(format: "Hours.Format.MonthsAgo".localized, month)
        }
        //Day
        if(day <= 547) {
            return "Hours.Format.AYearAgo".localized
        }
        let year = Int(-timeInterval / 60 / 60 / 24 / 365)
        return String(format: "Hours.Format.YearsAgo".localized, year)
    }

    public func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }

    public func getDate(with distanceDays: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: distanceDays, to: self)
    }

    public func distanceFromNow() -> DateComponents {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: self)
        return components
    }

    public func startOfMonth() -> Date {
        let dateFrom = Calendar.current.startOfDay(for: self)
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: dateFrom))!
    }

    public func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: 0), to: self.startOfMonth())!
    }
}
