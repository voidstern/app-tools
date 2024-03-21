//
//  RatingManager.swift
//  AppToolsMobile
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import StoreKit
import AppTools
import UIKit

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
        guard let windowScene = controller.view.window?.windowScene else {
            return
        }
        
        SKStoreReviewController.requestReview(in: windowScene)
        UserSettings.shared.set(value: Date().timeIntervalSince1970, key: .lastRatedDate)
    }
}
