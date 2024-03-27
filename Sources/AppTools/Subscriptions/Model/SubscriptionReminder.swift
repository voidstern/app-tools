//
//  SubscriptionReminder.swift
//  AppToolsMobile
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import AppTools
import StoreKit

public extension UserSettings.Setting {
    static var reminderEvents: UserSettings.Setting {
        return UserSettings.Setting(identifier: "reminder_events")
    }

    static var lastRemindedDate: UserSettings.Setting {
        return UserSettings.Setting(identifier: "last_reminded_date")
    }
}

public class SubscriptionReminder: ObservableObject {
    @Published public var showPurchaseView: Bool = false
    
    private let requiredEvents: Int
    private let requiredDays: Int
    private let subscriptionManager: SubscriptionManager
    private let threeDays: TimeInterval = 24 * 60 * 60

    public init(requiredEvents: Int, requiredDays: Int, subscriptionManager: SubscriptionManager) {
        self.subscriptionManager = subscriptionManager
        self.requiredEvents = requiredEvents
        self.requiredDays = requiredDays
    }
    
    public func triggerAppLaunch() {
        DispatchQueue.main.async(after: 0.5) {
            self.triggerPurchaseViewIfNeeded()
        }
    }

    public func triggerEvent() {
        let _: Int = UserSettings.shared.increment(.reminderEvents)
        triggerPurchaseViewIfNeeded()
    }
    
    private func triggerPurchaseViewIfNeeded() {
        guard subscriptionManager.subscriptionLevel == .free else {
            return
        }
        
        let events: Int = UserSettings.shared.integer(key: .reminderEvents)
        let lastRating = UserSettings.shared.double(key: .lastRemindedDate) as TimeInterval
        let timePassed = Date().timeIntervalSince1970 - lastRating

        if true { // events >= requiredEvents || timePassed > threeDays {
            UserSettings.shared.set(value: Date().timeIntervalSince1970, key: .lastRemindedDate)
            UserSettings.shared.set(value: 0, key: .reminderEvents)
            showPurchaseView = true
        }
    }
}
