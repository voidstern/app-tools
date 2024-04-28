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
            .sheet(item: $presentedURL) { url in
                SafariWebView(url: url)
                    .ignoresSafeArea()
            }
#endif
            .onAppear {
                if upgradeContext.fadeInCloseButton {
                    DispatchQueue.main.async(after: 5.0) {
                        closeButtonVisible = true
                    }
                } else {
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
            .frame(idealWidth: 560, idealHeight: 640)
#endif
            .if(upgradeContext.prefersDarkMode) { view in
                view.preferredColorScheme(.dark)
            }
            .interactiveDismissDisabled()
            .navigationTitle(upgradeContext.title)
            .navigationBarTitleDisplayMode(.inline)
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
        Button(action: performClose, label: {
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
#if os(macOS)
                        .font(.system(size: 21, weight: .regular))
#else
                        .font(.system(size: 19, weight: .regular))
#endif
                        Text(feature.title)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
#if os(macOS)
                        .font(.system(size: 17, weight: .regular))
#else
                        .font(.system(size: 19, weight: .regular))
#endif
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
                    Text(upgradeContext.subscriptionTerms(subscriptionPrice: subscriptionPrice))
#if os(macOS)
                        .font(.system(size: 13, weight: .regular))
#else
                        .font(.system(size: 15, weight: .regular))
#endif
                        .opacity(0.5)
                        .padding(.bottom, 8)
                    
                    Button(action: purchaseSubscription, label: {
                        Text(L10n.continue)
                    })
                    .buttonStyle(PurchaseButtonStyle())
                    .padding(.horizontal, 32)
                    .padding(.bottom, 4)
                    .buttonStyle(.plain)
                }
                
                HStack(spacing: 16) {
                    Button(action: showTermsOfService, label: {
                        Text(L10n.termsOfService)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.foreground)
                            .minimumScaleFactor(0.5)
                            .opacity(0.3)
                    })
                    .buttonStyle(.plain)
                    .foregroundStyle(.foreground)
                    .minimumScaleFactor(0.5)
                    
                    Button(action: showPrivacyPolicy, label: {
                        Text(L10n.privacyPolicy)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.foreground)
                            .minimumScaleFactor(0.5)
                            .opacity(0.3)
                    })
                    .buttonStyle(.plain)
                    .foregroundStyle(.foreground)
                    .minimumScaleFactor(0.5)
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 32)
            }
        }
    }
    
    private func restorePurchases() {
        subscriptionManager.restorePurchases {
            if subscriptionManager.subscription != nil {
                performClose()
            }
        }
    }
    
    private func purchaseSubscription() {
        subscriptionManager.purchase(subscription: upgradeContext.subscription) {
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
