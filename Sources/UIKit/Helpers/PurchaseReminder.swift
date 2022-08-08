//
//  PurchaseReminder.swift
//  AppToolsMobile
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

public extension UserSettings.Setting {
    static var reminderEvents: UserSettings.Setting {
        return UserSettings.Setting(identifier: "reminder_events")
    }

    static var lastRemindedDate: UserSettings.Setting {
        return UserSettings.Setting(identifier: "last_reminded_date")
    }
}

public protocol PurchaseReminderDelegate {
    func purchaseReminderShouldRemind(_ purchaseReminder: PurchaseReminder)
    func purchaseReminderIsAlreadyPro(_ purchaseReminder: PurchaseReminder) -> Bool
}

public class PurchaseReminder {
    let requiredEvents: Int
    let requiredDays: Int

    let threeDays: TimeInterval = 24 * 60 * 60
    public var delegate: PurchaseReminderDelegate?

    public init(requiredEvents: Int, requiredDays: Int) {
        self.requiredEvents = requiredEvents
        self.requiredDays = requiredDays
    }
    
    public func triggerAppLaunch() {
        triggerPurchaseViewIfNeeded()
    }

    public func triggerEvent() {
        let _: Int = UserSettings.shared.increment(.reminderEvents)
        triggerPurchaseViewIfNeeded()
    }
    
    private func triggerPurchaseViewIfNeeded() {
        let events: Int = UserSettings.shared.integer(key: .reminderEvents)

        let lastRating = UserSettings.shared.double(key: .lastRemindedDate) as TimeInterval
        let timePassed = Date().timeIntervalSince1970 - lastRating

        if events >= requiredEvents || timePassed > threeDays {
            UserSettings.shared.set(value: Date().timeIntervalSince1970, key: .lastRemindedDate)
            UserSettings.shared.set(value: 0, key: .reminderEvents)
            delegate?.purchaseReminderShouldRemind(self)
        }
    }
}
