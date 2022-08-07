//
//  DateFormat.swift
//  Greendrive
//
//  Created by Lukas on 24.11.18.
//  Copyright © 2018 Gutschi.Net. All rights reserved.
//

import Foundation

private var timeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

private var shortDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

private var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

private var dateTimeFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

private var iso8601Formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return dateFormatter
}()

public extension Date {
    var shortDateString: String {
        return shortDateFormatter.string(from: self)
    }
    
    var dateString: String {
        return dateFormatter.string(from: self)
    }
    
    var timeString: String {
        return timeFormatter.string(from: self)
    }
    
    var dateTimeString: String {
        return dateTimeFormatter.string(from: self)
    }
    
    var iso9601: String {
        return iso8601Formatter.string(from: self)
    }
}

public extension String {
    var iso8601: Date? {
        return iso8601Formatter.date(from: self)
    }
}
