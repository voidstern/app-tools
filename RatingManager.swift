//
//  RatingManager.swift
//  AppToolsMobile
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

extension UserSettings.Setting {
    public static var ratingEvents: UserSettings.Setting {
        return UserSettings.Setting(identifier: "rating_events")
    }

    public static var lastRatedDate: UserSettings.Setting {
        return UserSettings.Setting(identifier: "last_rated_date")
    }
}

public class RatingManager {

    let requiredEvents: Int
    let requiredDays: Int
    let appName: String

    let threeMonths: TimeInterval = 7776000

    public init(requiredEvents: Int, requiredDays: Int, appName: String) {
        self.requiredEvents = requiredEvents
        self.requiredDays = requiredDays
        self.appName = appName
    }

    public func triggerEvent(on controller: UIViewController) {
        let events: Int = UserSettings.shared.increment(.ratingEvents)
        let days = UserSettings.shared.installAge

        let lastRating = UserSettings.shared.double(key: .lastRatedDate) as TimeInterval
        let timePassed = Date().timeIntervalSince1970 - lastRating

        if events >= requiredEvents && days >= requiredDays && timePassed > threeMonths  {
            showRatingDialog(on: controller)
        }
    }

    private func showRatingDialog(on controller: UIViewController) {
        if #available(iOSApplicationExtension 10.3, *) {
            SKStoreReviewController.requestReview()
        }
        UserSettings.shared.set(value: Date().timeIntervalSince1970, key: .lastRatedDate)
    }
}
