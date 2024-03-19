//
//  PurchaseSettingsHeader.swift
//  Tidur Timers
//
//  Created by Lukas Burgstaller on 28.02.24.
//  Copyright © 2024 Lukas Burgstaller. All rights reserved.
//

import Foundation
import SwiftUI

public struct PurchaseSettingsGetProHeader: View {
    let upgradeContext: UpgradeContext
    
    public init(upgradeContext: UpgradeContext) {
        self.upgradeContext = upgradeContext
    }
    
    public var body: some View {
        ZStack {
            NavigationLink {
                PurchaseView(upgradeContext.subscription, features: upgradeContext.features)
            } label: {
                EmptyView()
            }
            .opacity(0.0)
            .buttonStyle(PlainButtonStyle())
            
            content
        }
        .listRowBackground(Color.clear)
    }
    
    var content: some View {
        VStack(alignment: .center) {
            upgradeContext.proLogo
            
            Text(upgradeContext.subtitle)
                .lineLimit(2)
                .font(.system(size: 13))
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .opacity(0.5)
            
            Text("\(Image(systemSymbol: .arrowUpCircleFill)) \(L10n.upgradeNow)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(12)
                .background {
                    Color.accentColor
                        .opacity(0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
    }
}

public struct PurchaseSettingsProHeader: View {
    let upgradeContext: UpgradeContext
    
    public init(upgradeContext: UpgradeContext) {
        self.upgradeContext = upgradeContext
    }
    
    public var body: some View {
        ZStack {
            NavigationLink {
                SubscriptionStatusView()
            } label: {
                EmptyView()
            }
            .opacity(0.0)
            .buttonStyle(PlainButtonStyle())
            
            content
        }
        .listRowBackground(Color.clear)
    }
    
    var content: some View {
        VStack(alignment: .center) {
            upgradeContext.proLogo
            
            Text(L10n.thanksForYourSupport)
                .font(.system(size: 15, weight: .semibold))
                .opacity(0.7)
                .padding(.bottom, 2)
            
            Text("\(L10n.manageSubscription) \(Image(systemSymbol: .chevronRight))")
                .font(.system(size: 11))
                .opacity(0.3)
        }
        .frame(maxWidth: .infinity)
    }
}

