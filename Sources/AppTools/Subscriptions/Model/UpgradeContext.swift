//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 17.03.24.
//

import Foundation
import SwiftUI

public struct UpgradeContext {
    let proLogo: Image
    
    let title: String
    let subscription: SubscriptionManager.Subscription
    let features: [PurchaseView.Feature]
    let fadeInCloseButton: Bool
    let upgradeHeaderBackground: Bool
    
    public init(proLogo: Image, subscription: SubscriptionManager.Subscription, title: String, features: [PurchaseView.Feature], fadeInCloseButton: Bool = true, upgradeHeaderBackground: Bool = true) {
        self.proLogo = proLogo
        self.subscription = subscription
        self.features = features
        self.title = title
        self.fadeInCloseButton = fadeInCloseButton
        self.upgradeHeaderBackground = upgradeHeaderBackground
    }
    
    public func featureString(separator: String = " · ") -> String {
        features.map(\.title).joined(separator: separator)
    }
}

extension UpgradeContext {
    func subscriptionTerms(subscriptionPrice: String) -> String {
        switch (subscription.type, subscription.hasTrial) {
        case (.yearly, true):
            return L10n.daysFreeThenYear(subscription.trialDuration, subscriptionPrice)
            
        case (.yearly, false):
            return L10n.year(subscriptionPrice)
            
        case (.monthly, true):
            return L10n.daysFreeThenMonth(subscription.trialDuration, subscriptionPrice)
            
        case (.monthly, false):
            return L10n.month(subscriptionPrice)
            
        case (.testflight, _):
            return L10n.testFlightSubscriptionsAreNotChargedToYourCard
            
        case (.bimonthly, _):
            return "\(subscriptionPrice)/2 Months"
            
        case (.quarterly, _):
            return "\(subscriptionPrice)/3 Months"
            
        case (.free, _), (.legacy, _), (.other, _):
            return "???"
        }
    }
}
