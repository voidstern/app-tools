//
//  PurchaseView.swift
//  Focused
//
//  Created by Lukas Burgstaller on 02.03.24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

public struct PurchaseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State var closeButtonVisible: Bool = true
    @State var subscriptionPrice: String = "-,--"
    @State var presentedURL: URL?
    
    let subscription: SubscriptionManager.Subscription
    let features: [Feature]
    let onClose: (() -> ())?
    
    public init(_ subscription: SubscriptionManager.Subscription, features: [Feature], onClose: (() -> Void)? = nil) {
        self.subscription = subscription
        self.features = features
        self.onClose = onClose
    }
    
    public var body: some View {
        content
            .navigationBarBackButtonHidden(true)
#if canImport(UIKit)
            .sheet(item: $presentedURL) { url in
                SafariWebView(url: url)
                    .ignoresSafeArea()
            }
#endif
            .onAppear {
                DispatchQueue.main.async(after: 5.0) {
                    closeButtonVisible = true
                }
                
                subscriptionManager.getProduct(for: subscription) { product in
                    subscriptionPrice = product.localizedPriceString
                }
            }
#if !os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    restoreButton
                }
                
                ToolbarItem(placement: .primaryAction) {
                    closeButton
                }
            }
#else
            .frame(idealWidth: 320, idealHeight: 560)
#endif
    }
    
    @ViewBuilder
    var restoreButton: some View {
        if subscriptionManager.isRestoring {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            Button(action: restorePurchases, label: {
                Text(L10n.restore)
            })
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: onClose ?? dismiss.callAsFunction, label: {
            Image(systemSymbol: .xmark)
        })
        .opacity(closeButtonVisible ? 0.3 : 0.0)
        .animation(.linear, value: closeButtonVisible)
        .buttonStyle(.plain)
    }
    
    var content: some View {
        VStack {
#if os(macOS)
            HStack {
                restoreButton
                
                Spacer()
                
                closeButton
            }
            .padding()
#endif
            Image("FocusedPro")
                .padding(.top, 32)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                
                ForEach (features) { feature in
                    
                    HStack {
                        Image(systemSymbol: feature.symbol)
                            .foregroundStyle(Color.accentColor)
                        Text(feature.title)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                if subscriptionManager.isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(height: 64)
                } else {
                    Button(action: purchaseSubscription, label: {
                        continueLabel
                    })
                    .padding(.horizontal, 32)
                    .buttonStyle(.plain)
                    
                    Text(subscriptionTerms)
#if os(macOS)
                        .font(.system(size: 13, weight: .regular))
#else
                        .font(.system(size: 15, weight: .regular))
#endif
                        .opacity(0.5)
                        .padding(.bottom, 16)
                }
                
                HStack(spacing: 16) {
                    Button(action: showTermsOfService, label: {
                        Text(L10n.termsOfService)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.foreground)
                            .opacity(0.3)
                    })
                    .foregroundStyle(.foreground)
                    
                    Button(action: showPrivacyPolicy, label: {
                        Text(L10n.privacyPolicy)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.foreground)
                            .opacity(0.3)
                    })
                    .foregroundStyle(.foreground)
                }
                .padding(.bottom, 16)
            }
        }
    }
    
    var subscriptionTerms: String {
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
    
    var continueLabel: some View {
        Text(L10n.continue)
#if os(macOS)
            .font(.system(size: 15, weight: .regular))
            .frame(height: 44)
#else
            .font(.system(size: 19, weight: .semibold))
            .frame(height: 64)
#endif
            .foregroundStyle(.background)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background {
                Color.accentColor
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
    }
    
    private func restorePurchases() {
        subscriptionManager.restorePurchases {
            if subscriptionManager.subscription != .free {
                (onClose ?? dismiss.callAsFunction)()
            }
        }
    }
    
    private func purchaseSubscription() {
        subscriptionManager.purchase(subscription: subscription) {
            if subscriptionManager.subscription != .free {
                (onClose ?? dismiss.callAsFunction)()
            }
        }
    }
    
    private func showTermsOfService() {
        presentedURL = URL(string: "https://voidstern.net/terms-of-use")!
    }
    
    private func showPrivacyPolicy() {
        presentedURL = URL(string: "https://voidstern.net/privacy-policy")!
    }
}

extension PurchaseView {
    public struct Feature: Identifiable {
        let title: String
        let symbol: SFSymbol
        
        public init(title: String, symbol: SFSymbol) {
            self.title = title
            self.symbol = symbol
        }
        
        public var id: String {
            title
        }
    }
}
