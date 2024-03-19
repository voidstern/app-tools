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
    
    let subscription: SubscriptionManager.Subscription
    let features: [PurchaseView.Feature]
    
    public init(proLogo: Image, subscription: SubscriptionManager.Subscription, features: [PurchaseView.Feature]) {
        self.proLogo = proLogo
        self.subscription = subscription
        self.features = features
    }
    
    public func featureString(separator: String = " · ") -> String {
        features.map(\.title).joined(separator: separator)
    }
}
