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
    @Environment(\.colorScheme) var colorScheme
    
    let upgradeContext: UpgradeContext
    
    public init(upgradeContext: UpgradeContext) {
        self.upgradeContext = upgradeContext
    }
    
    public var body: some View {
        ZStack {
            NavigationLink {
                PurchaseView(upgradeContext)
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
            
            Text(upgradeContext.featureString(separator: "\n"))
                .lineLimit(5)
                .font(.system(size: 13))
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .opacity(0.5)
            
            Text("\(Image(systemSymbol: .arrowUpCircleFill)) \(L10n.upgradeNow)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(12)
                .padding(.horizontal, 24)
                .background {
                    Color.accentColor
                        .opacity(0.7)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                }
                .padding(.top, 12)
                .shadow(color: .accentColor.opacity(0.5), radius: 10, x: 0, y: 2)
                .padding(.bottom, 8)
        }
        .background {
            VStack {
                Color.clear
                    .frame(height: 16)
                
                if upgradeContext.upgradeHeaderBackground {
                    if #available(iOS 17.0, watchOS 10.0, macOS 14.0, *) {
                        if colorScheme == .dark {
                            Color.clear.background(.background.secondary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Color.clear.background(.background)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    } else {
                        Color.clear.background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                Color.clear
                    .frame(height: 16)
            }
            .padding(.horizontal, -16)
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
                SubscriptionStatusView(upgradeContext: upgradeContext)
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

