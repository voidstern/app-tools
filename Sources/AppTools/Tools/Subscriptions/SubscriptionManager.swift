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
    @Published public private(set) var subscription: Subscription = .free
    
    private var products: [Subscription: StoreProduct] = [:]
    private let subscriptions: [Subscription]
    
    public init(subscriptions: [Subscription], revenueCatKey: String) {
        self.subscriptions = subscriptions
        
#if DEBUG
        Purchases.logLevel = .debug
#else
        Purchases.logLevel = .error
#endif
        Purchases.configure(withAPIKey: revenueCatKey)
        
//        Purchases.configure(with: Configuration.Builder(withAPIKey: "appl_QPJEAdJRFoqsrEsUFnCfgkvnvnw"))
//            .with(usesStoreKit2IfAvailable: true))
//        Purchases.shared.attribution.enableAdServicesAttributionTokenCollection()
    }
    
    public var rcid: String? {
        return Purchases.shared.appUserID
    }
    
    public var subscriptionLevel: SubscriptionLevel {
        return self.subscription.level
    }
    
    public var levels: [SubscriptionLevel] {
        return subscriptions.map(\.level)
    }
    
    public var endDate: Date? {
        guard let entitlementID = subscription.level.entitlement else {
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
    
    private func updateSubscriptionLevel() {
#if !DEBUG
        if let purchaserInfo = purchaserInfo {
            if purchaserInfo.entitlements.active.keys.contains(SubscriptionManager.proEntitlementId) {
                subscription = .pro
                return
            }
        }
        
        subscription = .free
#endif
    }
    
    public func updateCustomerInfo(completion: (() -> ())? = nil) {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let customerInfo = customerInfo {
                self.purchaserInfo = customerInfo
                UserSettings.shared.set(value: self.subscription.identifier, key: .proSubscriptionActive)
            }
            
            completion?()
        }
    }
    
    public func restorePurchases(completion: @escaping () -> ()) {
        isRestoring = true
        Purchases.shared.restorePurchases { customerInfo, error in
            if let customerInfo = customerInfo {
                self.purchaserInfo = customerInfo
                UserSettings.shared.set(value: self.subscription.identifier, key: .proSubscriptionActive)
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
