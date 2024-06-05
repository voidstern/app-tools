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
    let contextName: String
    let subscription: SubscriptionManager.Subscription
    let features: [PurchaseView.Feature]
    let highlightedFeature: PurchaseView.Feature?
    let fadeInCloseButton: Bool
    let upgradeHeaderBackground: Bool
    let prefersDarkMode: Bool
    
    public init(_ contextName: String, proLogo: Image, subscription: SubscriptionManager.Subscription, title: String, features: [PurchaseView.Feature], highlightedFeature: PurchaseView.Feature? = nil, fadeInCloseButton: Bool = true, prefersDarkMode: Bool = false, upgradeHeaderBackground: Bool = true) {
        self.proLogo = proLogo
        self.subscription = subscription
        self.features = features
        self.title = title
        self.fadeInCloseButton = fadeInCloseButton
        self.upgradeHeaderBackground = upgradeHeaderBackground
        self.prefersDarkMode = prefersDarkMode
        self.contextName = contextName
        self.highlightedFeature = highlightedFeature
    }
    
    public func featureString(separator: String = " · ") -> String {
        features.prefix(3).map(\.title).joined(separator: separator)
    }
    
    public var useListStylePurchaseView: Bool {
        !features.filter({ $0.subtitle != nil }).isEmpty || highlightedFeature != nil
    }
    
    public var listFeatures: [PurchaseView.Feature] {
        var listFeatures = features
        
        if let highlightedFeature {
            listFeatures.remove(highlightedFeature)
        }
        
        return listFeatures
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
