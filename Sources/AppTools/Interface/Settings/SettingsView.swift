//
//  SettingsView.swift
//  Focused
//
//  Created by Lukas Burgstaller on 01.03.24.
//

import Foundation
import SFSafeSymbols
import StoreKit
import SwiftUI

public struct SettingsView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State var showingEmail: Bool = false
    @State var showingiCloud: Bool = false
    
    private let upgradeInfo: UpgradeInfo
    private let supportMail: String
    private let content: Content
    
    public init(upgradeInfo: UpgradeInfo, supportMail: String, @ViewBuilder _ content: () -> Content) {
        self.upgradeInfo = upgradeInfo
        self.supportMail = supportMail
        self.content = content()
    }
    
    public var body: some View {
        NavigationStack {
            settingsContent
                .navigationTitle(L10n.settings)
#if !os(macOS)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: dismiss.callAsFunction, label: {
                            Text(L10n.done)
                                .fontWeight(.semibold)
                        })
                    }
                }
#endif
        }
    }
    
    private var settingsContent: some View {
        
        List {
            Group {
                if subscriptionManager.subscription == upgradeInfo.subscription {
                    PurchaseSettingsProHeader(upgradeInfo: upgradeInfo)
                } else {
                    PurchaseSettingsGetProHeader(upgradeInfo: upgradeInfo)
                }
            }
#if os(macOS)
            .listRowSeparator(.hidden, edges: .all)
#endif
            
            content
            
            Section(L10n.contact) {
                ButtonSettingsCell(image: Image(systemSymbol: .envelopeFill), title: L10n.email) {
                    SupportMailContent().emailURL(email: supportMail, rcid: subscriptionManager.rcid)?.open()
                }
                
                ButtonSettingsCell(image: Image("TwitterIcon", bundle: .module), title: "Twitter") {
                    URL(string: "https://twitter.com/voidstern")?.open()
                }
                
                ButtonSettingsCell(image: Image("MastodonIcon", bundle: .module), title: "Mastodon") {
                    URL(string: "http://graz.social/web/@voidstern")?.open()
                }
            }
            
            Section {
                OtherAppSettingsCell(appIcon: Image("FieryFeeds", bundle: .module), title: L10n.fieryFeedsRSSReader, subtitle: L10n.aNewsReaderForPowerUsers, action: showFieryFeeds)
                OtherAppSettingsCell(appIcon: Image("TidurTimers", bundle: .module), title: L10n.tidurMultipleTimers, subtitle: L10n.hiitPomodoroAndMore, action: showTidur)
                OtherAppSettingsCell(appIcon: Image("Dozzzer", bundle: .module), title: L10n.dozzzerSleepSounds, subtitle: L10n.fallAsleepToMusicSounds, action: showDozzzer)
            } header: { Text(L10n.otherApps) } footer: { footerView }
        }
    }
    
    var footerView: some View {
        ZStack(alignment: .center) {
            Color.clear
            Image(systemSymbol: .staroflifeCircleFill)
                .onTapGesture { URL(string: "https://voidstern.net/")?.open() }
                .font(.system(size: 32))
                .foregroundStyle(.background)
                .padding(.top, 32)
        }
    }
    
    private func showFieryFeeds() {
        URL(string: "https://apps.apple.com/app/apple-store/id1158763303")?.open()
    }
    
    private func showTidur() {
        URL(string: "https://apps.apple.com/app/apple-store/id720812035")?.open()
    }
    
    private func showDozzzer() {
        URL(string: "https://apps.apple.com/app/apple-store/id429674741")?.open()
    }
}

