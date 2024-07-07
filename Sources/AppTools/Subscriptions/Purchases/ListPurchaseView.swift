//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 07.07.24.
//

import Foundation
import SwiftUI

struct ListPurchaseView: View {
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
        content
    }
    
    var content: some View {
        ZStack {
            List {
                if let feature = upgradeContext.highlightedFeature {
                    FeatureListCell(feature: feature)
                }
                
                Section {
                    ForEach (upgradeContext.listFeatures) { feature in
                        FeatureListCell(feature: feature)
                    }
                }
            }
            .scrollClipDisabled()
            .padding(.top, 96)
            .padding(.bottom, 164)
            .zIndex(0)
#if os(visionOS)
            .frame(depth: 0)
#endif
            
            VStack {
                HStack {
                    Color.clear
                        .frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    upgradeContext.proLogo
                    
                    Spacer()
                    
                    closeButton
                        .frame(width: 44, height: 44)
                }
                .frame(height: 64)
                .padding()
                .background(.thinMaterial)
                
                Spacer()
                
                VStack(spacing: 8) {
                    if subscriptionManager.isWorking {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.small)
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
                        
                        if subscriptionManager.isRestoring {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(width: 22, height: 22, alignment: .center)
                        } else {
                            Button(action: restorePurchases, label: {
                                Text(L10n.restore)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundStyle(.foreground)
                                    .minimumScaleFactor(0.5)
                                    .opacity(0.3)
                            })
                            .buttonStyle(.plain)
                            .foregroundStyle(.foreground)
                            .minimumScaleFactor(0.5)
                        }
                    }
                    .padding(.bottom, 16)
                    .padding(.horizontal, 32)
                }
                .frame(height: 164)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
#if os(visionOS)
                .frame(depth: 50)
#endif
            }
            .zIndex(1)
#if os(visionOS)
            .frame(depth: 50)
#endif
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
}
