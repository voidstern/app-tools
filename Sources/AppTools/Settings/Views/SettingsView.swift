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
    
    private let upgradeContext: UpgradeContext
    private let settingsContext: SettingsContext
    private let content: Content
    
    public init(upgradeContext: UpgradeContext, settingsContext: SettingsContext, @ViewBuilder _ content: () -> Content) {
        self.upgradeContext = upgradeContext
        self.settingsContext = settingsContext
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
                if subscriptionManager.subscriptionLevel == upgradeContext.subscription.level {
                    PurchaseSettingsProHeader(upgradeContext: upgradeContext)
                } else {
                    PurchaseSettingsGetProHeader(upgradeContext: upgradeContext)
                }
            }
#if os(macOS)
            .listRowSeparator(.hidden, edges: .all)
#endif
            
            content
            
            Section(L10n.contact) {
                ButtonSettingsCell(image: Image(systemSymbol: .envelopeFill), title: L10n.email, tint: tint(index: 0)) {
                    SupportMailContent().emailURL(email: settingsContext.supportMail, rcid: subscriptionManager.rcid)?.open()
                }
                
                ButtonSettingsCell(image: Image("TwitterIcon", bundle: .module), title: "Twitter", tint: tint(index: 1)) {
                    URL(string: "https://twitter.com/voidstern")?.open()
                }
                
                ButtonSettingsCell(image: Image("MastodonIcon", bundle: .module), title: "Mastodon", tint: tint(index: 2)) {
                    URL(string: "http://graz.social/web/@voidstern")?.open()
                }
            }
            
            Section(L10n.support) {
                if let userGuideURL = settingsContext.userGuideURL {
                    ButtonSettingsCell(image: Image(systemSymbol: .command), title: L10n.userGuide, tint: tint(index: 3)) {
                        userGuideURL.open()
                    }
                }
                
                if let changelogURL = settingsContext.changelogURL {
                    ButtonSettingsCell(image: Image(systemSymbol: .listBulletClipboard), title: L10n.changelog, tint: tint(index: 4)) {
                        changelogURL.open()
                    }
                }
                
                if let reviewURL = settingsContext.reviewURL {
                    ButtonSettingsCell(image: Image(systemSymbol: .starBubble), title: L10n.review(settingsContext.appName), tint: tint(index: 5)) {
                        reviewURL.open()
                    }
                }
            }
            
            Section {
                if settingsContext.appID != "1158763303" {
                    OtherAppSettingsCell(appIcon: Image("FieryFeeds", bundle: .module), title: L10n.fieryFeedsRSSReader, subtitle: L10n.aNewsReaderForPowerUsers) {
                        URL(string: "https://apps.apple.com/app/apple-store/id1158763303")?.open()
                    }
                }
                
                if settingsContext.appID != "720812035" {
                    OtherAppSettingsCell(appIcon: Image("TidurTimers", bundle: .module), title: L10n.tidurMultipleTimers, subtitle: L10n.hiitPomodoroAndMore) {
                        URL(string: "https://apps.apple.com/app/apple-store/id720812035")?.open()
                    }
                }
                
                if settingsContext.appID != "429674741" {
                    OtherAppSettingsCell(appIcon: Image("Dozzzer", bundle: .module), title: L10n.dozzzerSleepSounds, subtitle: L10n.fallAsleepToMusicSounds) {
                        URL(string: "https://apps.apple.com/app/apple-store/id429674741")?.open()
                    }
                }
                
                if settingsContext.appID != "6478582777" {
                    OtherAppSettingsCell(appIcon: Image("Focused", bundle: .module), title: L10n.focusedTaskPlanner, subtitle: L10n.oneStepAtATime) {
                        URL(string: "https://apps.apple.com/us/app/focused-task-planner/id6478582777")?.open()
                    }
                }
                
            } header: { Text(L10n.otherApps) } footer: { footerView }
        }
    }
    
    var footerView: some View {
        ZStack(alignment: .center) {
            Color.clear
            Image(systemSymbol: .staroflifeCircleFill)
                .onTapGesture { URL(string: "https://voidstern.net/")?.open() }
                .font(.system(size: 32))
                .foregroundStyle(.gray)
                .opacity(0.4)
                .padding(.top, 32)
        }
    }
    
    func tint(index: Int) -> Color {
        settingsContext.tintColors.objectOrNil(at: index % settingsContext.tintColors.count) ?? .accentColor
    }
}

public struct SettingsContext {
    let appID: String
    let appName: String
    let supportMail: String
    
    let userGuideURL: URL?
    let changelogURL: URL?
    let reviewURL: URL?
        
    let tintColors: [Color]
    
    public init(appID: String, appName: String, supportMail: String, userGuideURL: URL?, changelogURL: URL?, reviewURL: URL?, tintColors: [Color] = []) {
        self.appID = appID
        self.appName = appName
        self.supportMail = supportMail
        self.userGuideURL = userGuideURL
        self.changelogURL = changelogURL
        self.reviewURL = reviewURL
        self.tintColors = tintColors
    }
}
