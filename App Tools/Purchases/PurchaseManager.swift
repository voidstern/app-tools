//
//  StoreManager.swift
//  Multi Timers 2
//
//  Created by Lukas Burgstaller on 20/10/2016.
//  Copyright © 2016 Lukas Burgstaller. All rights reserved.
//

import Foundation
import StoreKit

final public class PurchaseManager: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    public static let loadedPurchasesNotificationName = Notification.Name("loadedPurchasesNotification")
    public static let purchasedProductNotificationName = Notification.Name("purchasedProductNotificationName")
    public static let purchaseProductFailedNotificationName = Notification.Name("purchaseProductFailedNotificationName")
    public static let restoringPurchasesFinished = Notification.Name("restoringPurchasesFinished")

    open class Product: Equatable {
        public let identifier: String
        public init(identifier: String) {
            self.identifier = identifier
        }

        public static func == (lhs: Product, rhs: Product) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    private let userDefaultsKey = "purchases"
    private let testMode: Bool = false

    public static let defaultManager = PurchaseManager()

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        loadPurchases()
    }

    private var productsForPurchase: [Product] = []
    private var purchasedProducts: [Product] = []
    private var products: [SKProduct] = []

    // MARK: Access

    public func localizedPrice(for product: Product) -> String? {
        if let product = products.filter({ $0.productIdentifier == product.identifier}).first {
            return price(for: product)
        }

        loadProducts([product])
        return nil
    }

    public func isPurchased(_ product: Product) -> Bool {
        return purchasedProducts.contains(product)
    }

    public func purchase(_ product: Product) {
        guard testMode == false else {
            purchasedProducts.append(product)
            savePurchases()
            NotificationCenter.default.post(name: PurchaseManager.purchasedProductNotificationName, object: self)
            return
        }

        guard !isPurchased(product) else {
            NotificationCenter.default.post(name: PurchaseManager.purchasedProductNotificationName, object: self)
            return
        }

        if let storeProduct = products.filter({ return $0.productIdentifier == product.identifier }).first {
            purchaseProduct(storeProduct)
        } else {
            productsForPurchase.append(product)
            loadProducts([product])
        }
    }

    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: Storage

    private func savePurchases() {
        guard testMode == false else {
            return
        }

        let purchases = purchasedProducts.map({ $0.identifier })
        UserDefaults.standard.set(purchases, forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }

    private func loadPurchases() {
        guard testMode == false else {
            return
        }

        let loadedProducts = UserDefaults.standard.stringArray(forKey: userDefaultsKey)?.flatMap({ (string) -> Product? in
            return Product(identifier: string)
        })

        guard let products = loadedProducts else {
            return
        }

        for product in products {
            purchasedProducts.append(product)
        }
    }

    // MARK: Products

    private var activeRequest: SKProductsRequest? = nil

    public func loadProducts(_ products: [Product]) {
        activeRequest = SKProductsRequest(productIdentifiers: Set(products.map({ $0.identifier })))
        activeRequest?.delegate = self
        activeRequest?.start()
    }

    @objc public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products += response.products
        NotificationCenter.default.post(name: PurchaseManager.loadedPurchasesNotificationName, object: self)
    }

    // MARK: Price Formating

    private func price(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }

    // MARK: Payments

    private func purchaseProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().add(self)
    }

    @objc public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("Removed transaction: \(transactions)")
    }

    @objc public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == SKPaymentTransactionState.purchased || transaction.transactionState == SKPaymentTransactionState.restored {
                
                let product = Product(identifier: transaction.payment.productIdentifier)
                purchasedProducts.append(product)
                savePurchases()

                NotificationCenter.default.post(name: PurchaseManager.purchasedProductNotificationName, object: self)
                SKPaymentQueue.default().finishTransaction(transaction)
            }

            if transaction.transactionState == SKPaymentTransactionState.failed  {
                print("Transaction failed: \(String(describing: transaction.error?.localizedDescription))")
                NotificationCenter.default.post(name: PurchaseManager.purchaseProductFailedNotificationName, object: self)
            }
        }
    }

    @objc public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Restoring Transactions Failed: \(String(describing: error.localizedDescription))")
        NotificationCenter.default.post(name: PurchaseManager.restoringPurchasesFinished, object: self)
    }

    @objc public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        NotificationCenter.default.post(name: PurchaseManager.restoringPurchasesFinished, object: self)
    }
}
