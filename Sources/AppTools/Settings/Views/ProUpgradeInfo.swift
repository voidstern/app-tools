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
    let subtitle: String
    
    let subscription: SubscriptionManager.Subscription
    let features: [PurchaseView.Feature]
    
    public init(proLogo: Image, subtitle: String, subscription: SubscriptionManager.Subscription, features: [PurchaseView.Feature]) {
        self.proLogo = proLogo
        self.subtitle = subtitle
        self.subscription = subscription
        self.features = features
    }
}
