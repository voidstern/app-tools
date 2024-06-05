//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 28.05.24.
//

import Foundation

extension EventLogger.Event {
    static var purchaseViewViewed = EventLogger.Event(eventName: "purchaseViewViewed")
    static var purchaseViewPurchased = EventLogger.Event(eventName: "purchaseViewPurchased")
    static var purchaseViewRestored = EventLogger.Event(eventName: "purchaseViewRestore")
    static var purchaseViewSkipped = EventLogger.Event(eventName: "purchaseViewSkipped")
}

extension EventLogger.Event {
    static var purchaseRestored = EventLogger.Event(eventName: "purchaseRestore")
    static var purchasePurchased = EventLogger.Event(eventName: "purchasePurchased")
}
