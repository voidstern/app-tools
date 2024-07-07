//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 07.07.24.
//

import Foundation
import SwiftUI

struct SimplePurchaseView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @Binding var closeButtonVisible: Bool
    @Binding var subscriptionPrice: String
    
    let upgradeContext: UpgradeContext
    let restorePurchases: () -> ()
    let purchaseSubscription: () -> ()
    let showTermsOfService: () -> ()
    let showPrivacyPolicy: () -> ()
    let handleCloseButton: () -> ()
    
    var body: some View {
        purchaseContent
#if !os(macOS) && !os(watchOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    restoreButton
                }
                
                ToolbarItem(placement: .primaryAction) {
                    closeButton
                }
            }
#endif
    }
    
    var purchaseContent: some View {
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
                            .font(.system(size: .platform(21, macOS: 19), weight: .regular))
                        Text(feature.title)
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .font(.system(size: .platform(19, macOS: 17), weight: .regular))
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
                        .font(.system(size: .platform(15, macOS: 13), weight: .regular))
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
    
    @ViewBuilder
    var closeButton: some View {
        Button(action: handleCloseButton, label: {
            Image(systemSymbol: .xmark)
        })
        .opacity(closeButtonVisible ? 0.3 : 0.0)
        .animation(.linear, value: closeButtonVisible)
        .buttonStyle(.plain)
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
}
