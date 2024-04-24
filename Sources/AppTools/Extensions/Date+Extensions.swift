//
//  Date+Extensions.swift
//  Focused
//
//  Created by Lukas Burgstaller on 03.03.24.
//

import Foundation

extension Date {
    public var calendar: Calendar {
        Calendar.current
    }
    
    public var isPast: Bool {
        return timeIntervalSince(.today) < 0
    }
    
    public var isFuture: Bool {
        return timeIntervalSince(.today) >= 0
    }
}

// MARK: Day
// Date, at 0:00 of the day in question
public typealias Day = Date

extension Date {
    public var day: Day {
        return calendar.startOfDay(for: self)
    }
    
    public func adding(days: Int) -> Date {
        return addingTimeInterval(Double(days) * 24 * 60 * 60)
            .day
    }
    
    public static var today: Day {
        return Date().day
    }
}

// MARK: Week
// Date, at 0:00 of the week in question
public typealias Week = Date

extension Date {
    public var week: Week {
        return calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    
    public func adding(weeks: Int) -> Date {
        return addingTimeInterval(Double(weeks) * 7 * 24 * 60 * 60)
            .week
    }
    
    public static var currentWeek: Week {
        return Date().week
    }
}

extension Week {
    public static var weekdayStrings: [String] {
        let days: [String] = ["Son", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let firstDay = Calendar.current.firstWeekday - 1
        let weekdays = Array(days[firstDay...] + days[..<firstDay])
        return weekdays
    }
    
    public func dayNumberOfWeek() -> Int? {
        // Sun... 1, Mon.-- 2....
        switch Calendar.current.dateComponents([.weekday], from: self).weekday {
        case 1: return 6 // Sunday
        case 2: return 0
        case 3: return 1
        case 4: return 2
        case 5: return 3
        case 6: return 4
        case 7: return 5
        default: return nil
        }
    }
}

// MARK: Month
// Date, at 0:00 of the month in question
public typealias Month = Date

extension Date {
    public var month: Week {
        return calendar.dateComponents([.calendar, .year, .month], from: self).date!
    }
    
    public var daysInMonth: Int {
        let dateComponents = calendar.dateComponents([.year, .month], from: self)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    public func adding(months: Int) -> Date {
        return addingTimeInterval(Double(months) * 31 * 24 * 60 * 60)
            .month
    }
    
    public static var currentMonth: Week {
        return Date().month
    }
}

// MARK: Localized Names

extension Date {
    public var dayInMonthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    public var weekdayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    public var monthString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }
    
    public var weekInYearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ww"
        return dateFormatter.string(from: self)
    }
    
    public var yearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
}

extension TimeInterval {
    public var days: Int {
        return Int(ceil(self / (24 * 60 * 60)))
    }
}
