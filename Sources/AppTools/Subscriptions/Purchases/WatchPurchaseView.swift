//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 07.07.24.
//

import Foundation
import SwiftUI

struct WatchPurchaseView: View {
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
        ScrollView {
            VStack(spacing: 16) {
                upgradeContext.proLogo
                
                VStack(alignment: .leading, spacing: 4) {
                    ForEach (upgradeContext.features) { feature in
                        HStack {
                            Image(systemSymbol: feature.symbol)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(Color.accentColor)
                                .scaledToFit()
                                .frame(width: 32)
                            Text(feature.title)
                                .foregroundStyle(.primary)
                                .lineLimit(3)
                            
                            Spacer()
                        }
                        .padding(6)
                    }
                }
                
                if subscriptionManager.isWorking {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                } else {
                    Button(action: purchaseSubscription, label: {
                        VStack(spacing: 4) {
                            Text(L10n.continue)
                                .font(.system(size: 15, weight: .semibold))
                            
                            Text(upgradeContext.subscriptionTerms(subscriptionPrice: subscriptionPrice))
                                .font(.system(size: 13, weight: .light))
                                .multilineTextAlignment(.center)
                                .opacity(0.7)
                        }
                    })
                    .buttonStyle(.bordered)
                    
                    Button(action: restorePurchases, label: {
                        Text(L10n.restore)
                            .font(.system(size: 13, weight: .light))
                            .foregroundStyle(.white)
                    })
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}
