//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 21.03.24.
//

import Foundation

private let threeMonths: TimeInterval = 7776000

public extension UserSettings.Setting {
    static var ratingEvents: UserSettings.Setting {
        return UserSettings.Setting(identifier: "rating_events")
    }

    static var lastRatedDate: UserSettings.Setting {
        return UserSettings.Setting(identifier: "last_rated_date")
    }
}

public class RatingReminder {
    let requiredEvents: Int
    let requiredDays: Int
    let appName: String

    public init(requiredEvents: Int, requiredDays: Int, appName: String) {
        self.requiredEvents = requiredEvents
        self.requiredDays = requiredDays
        self.appName = appName
    }

    // @Environment(\.requestReview) private var requestReview
    public func triggerEvent(requestReview: () -> ()) {
        let events: Int = UserSettings.shared.increment(.ratingEvents)
        let days = UserSettings.shared.installAge

        let lastRating = UserSettings.shared.double(key: .lastRatedDate) as TimeInterval
        let timePassed = Date().timeIntervalSince1970 - lastRating

        if events >= requiredEvents && days >= requiredDays && timePassed > threeMonths {
            requestReview()
            UserSettings.shared.set(value: Date().timeIntervalSince1970, key: .lastRatedDate)
        }
    }
}
