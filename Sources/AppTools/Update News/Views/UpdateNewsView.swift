//
//  UpdateNewsView.swift
//  AppTools
//
//  Created by Lukas Burgstaller on 21.03.24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct UpdateNewsView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State var subscriptionPrice: String = "-,--"
    
    let upgradeContext: UpgradeContext
    let features: [UpdateNewsReminder.Feature]
    let title: String
    
    let onContinue: () -> ()
    
    var body: some View {
        content
            .frame(idealWidth: 560, idealHeight: 640)
            .onAppear {
                subscriptionManager.getProduct(for: upgradeContext.subscription) { product in
                    subscriptionPrice = product.localizedPriceString
                }
            }
    }
    
    var content: some View {
        VStack {
            Text(title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .font(.system(size: 32, weight: .bold))
                .padding(.vertical, 48)
                .padding(.horizontal, 32)
            
            VStack {
                ForEach(features) { feature in
                    HStack(spacing: 8) {
                        if let symbol = feature.symbol {
                            Image(systemSymbol: symbol)
                                .font(.system(size: 32))
                                .symbolRenderingMode(.hierarchical)
#if os(visionOS)
            .foregroundStyle(.white)
#else
            .foregroundStyle(feature.tint)
#endif
                                .frame(width: 64, height: 64)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(feature.title)
                                .bold()
                            Text(feature.description)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.trailing, 24)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            if subscriptionManager.isWorking {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(height: 64)
            } else {
                bottomButtons
            }
        }
        .frame(minWidth: 320, maxWidth: 640)
    }
    
    @ViewBuilder
    var bottomButtons: some View {
        if subscriptionManager.subscriptionLevel == .free {
            Button(L10n.continueWithoutUpgrade, action: continueHit)
                .buttonStyle(.plain)
                .padding(.bottom, 8)
            
            Button(action: upgradeSubscription, label: {
                continueLabel(text: L10n.upgradeNow)
            })
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
            .buttonStyle(.plain)
        } else {
            Button(action: continueHit, label: {
                continueLabel(text: L10n.continue)
            })
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
            .buttonStyle(.plain)
        }
    }
    
    func continueLabel(text: String) -> some View {
        Text(text)
#if os(macOS)
            .font(.system(size: 15, weight: .regular))
            .frame(height: 44)
#else
            .font(.system(size: 19, weight: .semibold))
            .frame(height: 64)
#endif
#if os(visionOS)
            .foregroundStyle(.white)
#else
            .foregroundStyle(.background)
#endif
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background {
                Color.accentColor
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
    }
    
    private func continueHit() {
        onContinue()
        dismiss()
    }

    private func upgradeSubscription() {
        subscriptionManager.purchase(subscription: upgradeContext.subscription) {
            if subscriptionManager.subscription != nil {
                onContinue()
            }
        }
    }
}

//#Preview {
//    UpdateNewsView(upgradeContext: UpgradeContext(proLogo: Image(systemSymbol: .arrowUp), subscription: .init(identifier: "", level: .free, type: .monthly, trialDuration: 7), title: "Pro Subsscription", features: []),
//                   features: [.init("New Feature", description: "Some longer Feature Description for the app", symbol: .applepencil, tint: .orange)],
//                   title: "What's new in App",
//                   onContinue: {})
//}
