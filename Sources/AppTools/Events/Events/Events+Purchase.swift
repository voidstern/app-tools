//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 28.05.24.
//

import Foundation

extension EventLogger.Event {
    static var purchaseViewViewed = EventLogger.Event(eventName: "purchase_view_viewed")
    static var purchaseViewPurchased = EventLogger.Event(eventName: "purchase_view_purchased")
    static var purchaseViewRestored = EventLogger.Event(eventName: "purchase_view_restore")
    static var purchaseViewSkipped = EventLogger.Event(eventName: "purchase_view_skipped")
}

extension EventLogger.Event {
    static var purchaseRestored = EventLogger.Event(eventName: "purchase_restore")
    static var purchasePurchased = EventLogger.Event(eventName: "purchase_purchased")
}
