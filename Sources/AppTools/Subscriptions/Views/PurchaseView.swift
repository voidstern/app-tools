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
    
    @State var closeButtonVisible: Bool = false
    @State var subscriptionPrice: String = "-,--"
    @State var presentedURL: URL?
    
    let upgradeContext: UpgradeContext
    let onClose: (() -> ())?
    
    public init(_ upgradeContext: UpgradeContext, onClose: (() -> Void)? = nil) {
        self.upgradeContext = upgradeContext
        self.onClose = onClose
    }
    
    public var body: some View {
        content
            .navigationBarBackButtonHidden(true)
#if canImport(UIKit) && !os(watchOS)
            .sheet(item: $presentedURL) { url in
                SafariWebView(url: url)
                    .ignoresSafeArea()
            }
#endif
            .onAppear {
                DispatchQueue.main.async(after: 3.0) {
                    closeButtonVisible = true
                }
                
                subscriptionManager.getProduct(for: upgradeContext.subscription) { product in
                    subscriptionPrice = product.localizedPriceString
                }
            }
#if !os(macOS) && !os(watchOS)
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
                .frame(width: 22, height: 22, alignment: .center)
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
            .frame(height: 44)
            .padding()
#endif
            upgradeContext.proLogo
                .padding(.top, 32)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 16) {
                ForEach (upgradeContext.features) { feature in
                    HStack {
                        Image(systemSymbol: feature.symbol)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color.accentColor)
                        Text(feature.title)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                    }
                    .padding(6)
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
                    .padding(.bottom, 4)
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
#if !os(macOS)
                            .minimumScaleFactor(0.5)
                            .opacity(0.3)
#endif
                    })
                    .foregroundStyle(.foreground)
                    .minimumScaleFactor(0.5)
                    
                    Button(action: showPrivacyPolicy, label: {
                        Text(L10n.privacyPolicy)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.foreground)
#if !os(macOS)
                            .minimumScaleFactor(0.5)
                            .opacity(0.3)
#endif
                    })
                    .foregroundStyle(.foreground)
                    .minimumScaleFactor(0.5)
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 32)
            }
        }
    }
    
    var subscriptionTerms: String {
        let subscription = upgradeContext.subscription
        
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
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
    }
    
    private func restorePurchases() {
        subscriptionManager.restorePurchases {
            if subscriptionManager.subscription != nil {
                (onClose ?? dismiss.callAsFunction)()
            }
        }
    }
    
    private func purchaseSubscription() {
        subscriptionManager.purchase(subscription: upgradeContext.subscription) {
            if subscriptionManager.subscription != nil {
                (onClose ?? dismiss.callAsFunction)()
            }
        }
    }
    
    private func showTermsOfService() {
#if os(macOS)
        URL(string: "https://voidstern.net/terms-of-use")?.open()
#else
        presentedURL = URL(string: "https://voidstern.net/terms-of-use")
#endif
    }
    
    private func showPrivacyPolicy() {
#if os(macOS)
        URL(string: "https://voidstern.net/privacy-policy")?.open()
#else
        presentedURL = URL(string: "https://voidstern.net/privacy-policy")
#endif
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
