//
//  PurchaseReminder.swift
//  AppToolsMobile
//
//  Created by Lukas on 02/09/2017.
//  Copyright © 2017 Lukas. All rights reserved.
//

import Foundation
import AppTools
import StoreKit
import UIKit

public protocol PurchaseReminderDelegate {
    func purchaseReminderShouldRemind(_ purchaseReminder: PurchaseReminder)
    func purchaseReminderIsAlreadyPro(_ purchaseReminder: PurchaseReminder) -> Bool
}

public class PurchaseReminder {
    let requiredEvents: Int
    let requiredDays: Int

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
        guard delegate?.purchaseReminderIsAlreadyPro(self) == false else {
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
            delegate?.purchaseReminderShouldRemind(self)
        }
    }
}
