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

@MainActor
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
        
        let events: Int = UserSettings.shared.integer(for: .reminderEvents)
        var lastRating = UserSettings.shared.double(for: .lastRemindedDate) as TimeInterval
        
        if lastRating == 0 {
            lastRating = UserSettings.shared.double(for: .installDate)
        }
        
        let timePassed = Date().timeIntervalSince1970 - lastRating
        let requiredTimePassed = TimeInterval(requiredDays * 24 * 60 * 60)

        if events >= requiredEvents && timePassed >= requiredTimePassed {
            UserSettings.shared.set(value: Date().timeIntervalSince1970, for: .lastRemindedDate)
            UserSettings.shared.set(value: 0, for: .reminderEvents)
            showPurchaseView = true
        }
    }
}
