//
//  SubscriptionManager.swift
//  Focused
//
//  Created by Lukas Burgstaller on 02.03.24.
//

import Foundation
import RevenueCat

public class SubscriptionManager: ObservableObject {
    public static let subscriptionChanged = Notification.Name("net.voidstern.focused.subscription.changed")
    
    @Published public private(set) var isRestoring: Bool = false
    @Published public private(set) var isWorking: Bool = false
    
    @Published public private(set) var subscription: Subscription?
    @Published public private(set) var subscriptionLevel: SubscriptionLevel = .free
    
    private var products: [Subscription: StoreProduct] = [:]
    private let subscriptions: [Subscription]
    private let levels: [SubscriptionLevel]
    private let userSettings: UserSettings = .shared
    private var debugUnlock: Subscription?
    
    public init(subscriptions: [Subscription], levels: [SubscriptionLevel], revenueCatKey: String, appGroupIdentifier: String? = nil, migrateAppGroupIfNeeded: Bool = false) {
        self.subscriptions = subscriptions
        self.levels = levels
        
//#if DEBUG
//        Purchases.logLevel = .debug
//#else
        Purchases.logLevel = .error
//#endif
        
        if let appGroupIdentifier, migrateAppGroupIfNeeded {
            self.migrateAppGroupIfNeeded(appGroupIdentifier: appGroupIdentifier)
        }
        
        Purchases.configure(
            with: Configuration.Builder(withAPIKey:revenueCatKey)
                .with(userDefaults: .init(suiteName: appGroupIdentifier)!)
                .build()
        )
        
        UserSettings.shared.set(value: Purchases.shared.appUserID, for: .revenuecatUserID)
        subscription = userSettings.codable(for: .lastKnownSubscription, of: Subscription.self)
        subscriptionLevel = userSettings.codable(for: .lastKnownSubscriptionLevel, of: SubscriptionLevel.self) ?? .free
        updateCustomerInfo()
    }
    
    public var rcid: String? {
        return Purchases.shared.appUserID
    }
    
    public var endDate: Date? {
        guard let entitlementID = subscriptionLevel.entitlement else {
            return nil
        }
        
        if let entitlementInfo = purchaserInfo?.entitlements.active[entitlementID] {
            return entitlementInfo.expirationDate
        }
        
        return nil
    }
    
    internal var purchaserInfo: RevenueCat.CustomerInfo? {
        didSet {
            updateSubscriptionLevel()
            NotificationCenter.default.post(name: SubscriptionManager.subscriptionChanged, object: self)
        }
    }
    
#if DEBUG
    public func debugUnlock(_ subscription: Subscription) {
        debugUnlock = subscription
        updateSubscriptionLevel()
    }
#endif
    
    private func migrateAppGroupIfNeeded(appGroupIdentifier: String) {
        let userDefaults = UserDefaults.standard
        let hasMigratedKey = "has_migrated_revenuecat"
        
        guard let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier) else {
            return
        }
        
        guard userDefaults.bool(forKey: hasMigratedKey) != true else {
            return
        }
        
        for entry in userDefaults.dictionaryRepresentation() {
            let (key, value) = entry
            
            if key.starts(with: "com.revenuecat.") {
                sharedDefaults.set(value, forKey: key)
            }
        }
        
        userDefaults.set(true, forKey: hasMigratedKey)
    }
    
    private func updateSubscriptionLevel() {
        UserSettings.shared.set(value: Purchases.shared.appUserID, for: .revenuecatUserID)
        
        if let debugUnlock {
            self.subscriptionLevel = debugUnlock.level
            userSettings.set(codable: debugUnlock.level, for: .lastKnownSubscriptionLevel)
            
            self.subscription = debugUnlock
            userSettings.set(codable: debugUnlock, for: .lastKnownSubscription)
            
            return
        }
        
        guard let purchaserInfo = purchaserInfo else {
            subscriptionLevel = .free
            return
        }
        
        var activeLevel: SubscriptionLevel = .free
        for entitlement in purchaserInfo.entitlements.active {
            if let level = self.levels.filter({ $0.entitlement == entitlement.key }).first, level.value > activeLevel.value {
                activeLevel = level
            }
        }
        
        var activeSubscription: Subscription? = nil
        for subscription in purchaserInfo.activeSubscriptions {
            if let mappedSubscription = self.subscriptions.filter({ $0.identifier == subscription }).first {
                activeSubscription = mappedSubscription
            }
        }
        
        self.subscriptionLevel = activeLevel
        userSettings.set(codable: activeLevel, for: .lastKnownSubscriptionLevel)
        
        self.subscription = activeSubscription
        userSettings.set(codable: activeSubscription, for: .lastKnownSubscription)
    }
    
    public func updateCustomerInfo(completion: (() -> ())? = nil) {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let customerInfo = customerInfo {
                self.purchaserInfo = customerInfo
            }
            
            completion?()
        }
    }
    
    public func restorePurchases(completion: @escaping () -> ()) {
        isRestoring = true
        Purchases.shared.restorePurchases { customerInfo, error in
            if let customerInfo = customerInfo {
                self.purchaserInfo = customerInfo
                
                if self.subscriptionLevel != .free {
                    EventLogger.shared.log(event: .purchaseRestored, parameters: ["level": self.subscriptionLevel.identifier])
                }
            }
            
            completion()
            self.isRestoring = false
        }
    }
    
    public func getProduct(for subscription: Subscription, completion: @escaping (StoreProduct) -> Void) {
        if let product = products[subscription] {
            completion(product)
        }
        
        Purchases.shared.getProducts([subscription.identifier]) { products in
            for product in products {
                if let identifier = self.subscriptions.filter({ $0.identifier == product.productIdentifier }).first {
                    self.products[identifier] = product
                }
            }
            
            if let product = self.products[subscription] {
                completion(product)
            }
        }
    }
    
    public func loadProducts() {
        let productIDs = subscriptions.map(\.identifier)
        
        Purchases.shared.getProducts(productIDs) { products in
            for product in products {
                if let identifier = self.subscriptions.filter({ $0.identifier == product.productIdentifier }).first {
                    self.products[identifier] = product
                }
            }
        }
    }
    
    public func purchase(subscription: Subscription, completion: @escaping () -> ()) {
        isWorking = true
        Purchases.shared.getProducts([subscription.identifier]) { products in
            if let product = products.first {
                Purchases.shared.purchase(product: product) { transaction, purchaserInfo, error, cancelled in
                    if let purchaserInfo = purchaserInfo {
                        self.purchaserInfo = purchaserInfo
                        
                        if self.subscriptionLevel != .free {
                            EventLogger.shared.log(event: .purchasePurchased, parameters: ["level": self.subscriptionLevel.identifier])
                            EventLogger.shared.log(event: .telemetryPurchase, parameters: ["TelemetryDeck.Purchase.type": transaction?.productIdentifier ?? "", "TelemetryDeck.Purchase.countryCode": transaction?.countryCode ?? "", "TelemetryDeck.Purchase.currencyCode": transaction?.currencyCode ?? ""], floatValue: transaction?.price)
                        }
                        
                        completion()
                    } else {
                        self.updateCustomerInfo(completion: completion)
                    }
                    self.isWorking = false
                }
            } else {
                self.updateCustomerInfo(completion: completion)
                self.isWorking = false
            }
        }
    }
}

extension StoreTransaction {
    var price: Float? {
        if let sk2Transaction, let price = sk2Transaction.price {
            return NSDecimalNumber(decimal: price).floatValue
        }
        
        return nil
    }
    
    var countryCode: String? {
        return storefront?.countryCode
    }
    
    var currencyCode: String? {
        if let sk2Transaction, let currency = sk2Transaction.currency {
            return currency.identifier
        }
        
        return nil
    }
}

extension UserSettings.Setting {
    public static let revenuecatUserID = UserSettings.Setting(identifier: "revenuecat_id")
    public static let lastKnownSubscription = UserSettings.Setting(identifier: "last_known_subscription")
    public static let lastKnownSubscriptionLevel = UserSettings.Setting(identifier: "last_known_subscription_level")
}

extension EventLogger.Event {
    public static let telemetryPurchase = EventLogger.Event(eventName: "TelemetryDeck.Purchase.completed")
}
