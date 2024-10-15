//
//  PurchaseView.swift
//  Focused
//
//  Created by Lukas Burgstaller on 02.03.24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

public struct PurchaseView: OnboardingSequenceView {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State var closeButtonVisible: Bool = false
    @State var subscriptionPrice: String = "-,--"
    @State var presentedURL: URL?
    
    public var nextOnboardingStep: (() -> ())?
    let upgradeContext: UpgradeContext
    let onClose: (() -> ())?
    
    public init(_ upgradeContext: UpgradeContext, onClose: (() -> Void)? = nil) {
        self.upgradeContext = upgradeContext
        self.onClose = onClose
    }
    
    public var body: some View {
        content
            .navigationBarBackButtonHidden(true)
#if os(iOS)
            .navigationTitle(upgradeContext.title)
            .sheet(item: $presentedURL) { url in
                SafariWebView(url: url)
                    .ignoresSafeArea()
            }
#endif
            .onAppear {
                if upgradeContext.fadeInCloseButton {
                    DispatchQueue.main.async(after: 3.0) {
                        closeButtonVisible = true
                    }
                } else {
                    closeButtonVisible = true
                }
                
                subscriptionManager.getProduct(for: upgradeContext.subscription) { product in
                    subscriptionPrice = product.localizedPriceString
                }
                
                EventLogger.shared.log(event: .purchaseViewViewed, parameters: ["context": upgradeContext.contextName])
            }
#if os(macOS)
            .frame(idealWidth: 560, idealHeight: 640)
#endif
            .if(upgradeContext.prefersDarkMode) { view in
                view.preferredColorScheme(.dark)
            }
            .interactiveDismissDisabled()
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(upgradeContext.useListStylePurchaseView ? .hidden : .automatic, for: .navigationBar)
#endif
    }
    
    @ViewBuilder
    var restoreButton: some View {
        if subscriptionManager.isRestoring {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 22, height: 22, alignment: .center)
                .controlSize(.small)
        } else {
            Button(action: restorePurchases, label: {
                Text(L10n.restore)
            })
            .buttonStyle(.plain)
        }
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: {
        }, label: {
            Image(systemSymbol: .xmark)
        })
        .opacity(closeButtonVisible ? 0.3 : 0.0)
        .animation(.linear, value: closeButtonVisible)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var content: some View {
#if os(watchOS)
        WatchPurchaseView(closeButtonVisible: $closeButtonVisible, subscriptionPrice: $subscriptionPrice, upgradeContext: upgradeContext, restorePurchases: restorePurchases, purchaseSubscription: purchaseSubscription, showTermsOfService: showTermsOfService, showPrivacyPolicy: showPrivacyPolicy, handleCloseButton: handleCloseButton)
#else
        if upgradeContext.useListStylePurchaseView {
            ListPurchaseView(closeButtonVisible: $closeButtonVisible, subscriptionPrice: $subscriptionPrice, upgradeContext: upgradeContext, restorePurchases: restorePurchases, purchaseSubscription: purchaseSubscription, showTermsOfService: showTermsOfService, showPrivacyPolicy: showPrivacyPolicy, handleCloseButton: handleCloseButton)
        } else {
            SimplePurchaseView(closeButtonVisible: $closeButtonVisible, subscriptionPrice: $subscriptionPrice, upgradeContext: upgradeContext, restorePurchases: restorePurchases, purchaseSubscription: purchaseSubscription, showTermsOfService: showTermsOfService, showPrivacyPolicy: showPrivacyPolicy, handleCloseButton: handleCloseButton)
        }
#endif
    }
    
    private func handleCloseButton() {
        EventLogger.shared.log(event: .purchaseViewSkipped, parameters: ["context": upgradeContext.contextName])
        performClose()
    }
    
    private func restorePurchases() {
        EventLogger.shared.log(event: .purchaseViewRestored, parameters: ["context": upgradeContext.contextName])
        
        subscriptionManager.restorePurchases {
            if subscriptionManager.subscription != nil {
                performClose()
            }
        }
    }
    
    private func purchaseSubscription() {
        EventLogger.shared.log(event: .purchaseViewPurchased, parameters: ["context": upgradeContext.contextName])
        
        subscriptionManager.purchase(subscription: upgradeContext.subscription, context: upgradeContext) {
            if subscriptionManager.subscription != nil {
                performClose()
            }
        }
    }
    
    private func showTermsOfService() {
#if os(iOS)
        presentedURL = URL(string: "https://voidstern.net/terms-of-use")
#else
        URL(string: "https://voidstern.net/terms-of-use")?.open()
#endif
    }
    
    private func showPrivacyPolicy() {
#if os(iOS)
        presentedURL = URL(string: "https://voidstern.net/privacy-policy")
#else
        URL(string: "https://voidstern.net/privacy-policy")?.open()
#endif
    }
    
    private func performClose() {
        if let nextOnboardingStep {
            nextOnboardingStep()
        } else if let onClose {
            onClose()
        } else {
            dismiss()
        }
    }
}

extension PurchaseView {
    public struct Feature: Identifiable, Hashable, Equatable, Sendable {
        let title: String
        let subtitle: String?
        let symbol: SFSymbol
        let emoji: String?
        
        public init(title: String, subtitle: String? = nil, symbol: SFSymbol, emoji: String? = nil) {
            self.title = title
            self.symbol = symbol
            self.subtitle = subtitle
            self.emoji = emoji
        }
        
        public var id: String {
            title
        }
    }
}

struct FeatureListCell: View {
    let feature: PurchaseView.Feature
    
    var body: some View {
        HStack {
            Image(systemSymbol: feature.symbol)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.accentColor)
                .font(.system(size: .platform(27, macOS: 21), weight: .regular))
                .scaledToFit()
                .frame(width: 54, height: 54)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(feature.title)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .font(.system(size: .platform(17, macOS: 15), weight: .semibold))
                
                Text(feature.subtitle ?? "")
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .font(.system(size: .platform(15, macOS: 13), weight: .regular))
                    .opacity(0.7)
            }
            
            Spacer()
        }
    }
}
