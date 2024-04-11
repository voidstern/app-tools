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
        NavigationView {
            settingsContent
                .frame(idealWidth: 360)
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
            
            Section(L10n.support) {
                ButtonSettingsCell(image: Image(systemSymbol: .envelope), title: L10n.email, tint: tint(index: 0)) {
                    SupportMailContent().emailURL(email: settingsContext.supportMail, rcid: subscriptionManager.rcid)?.open()
                }
                
//                if let userGuideURL = settingsContext.userGuideURL {
//                    ButtonSettingsCell(image: Image(systemSymbol: .command), title: L10n.userGuide, tint: tint(index: 3)) {
//                        userGuideURL.open()
//                    }
//                }
                
                NavigationSettingsCell(image: Image(systemSymbol: .infoCircle), title: L10n.about) {
                    AboutView(settingsContext: settingsContext)
                }
            }
            
            Section {
                if settingsContext.appID != "1158763303" {
                    OtherAppSettingsCell(appIcon: Image("1158763303", bundle: .module), title: L10n.fieryFeedsRSSReader, subtitle: L10n.aNewsReaderForPowerUsers) {
                        URL(string: "https://apps.apple.com/app/apple-store/id1158763303")?.open()
                    }
                }
                
                if settingsContext.appID != "720812035" {
                    OtherAppSettingsCell(appIcon: Image("720812035", bundle: .module), title: L10n.tidurMultipleTimers, subtitle: L10n.hiitPomodoroAndMore) {
                        URL(string: "https://apps.apple.com/app/apple-store/id720812035")?.open()
                    }
                }
                
                if settingsContext.appID != "429674741" {
                    OtherAppSettingsCell(appIcon: Image("429674741", bundle: .module), title: L10n.dozzzerSleepSounds, subtitle: L10n.fallAsleepToMusicSounds) {
                        URL(string: "https://apps.apple.com/app/apple-store/id429674741")?.open()
                    }
                }
                
                if settingsContext.appID != "6478582777" {
                    OtherAppSettingsCell(appIcon: Image("6478582777", bundle: .module), title: L10n.focusedTaskPlanner, subtitle: L10n.oneStepAtATime) {
                        URL(string: "https://apps.apple.com/us/app/focused-task-planner/id6478582777")?.open()
                    }
                }
                
            } header: { Text(L10n.otherApps) } footer: { footerView }
            
#if os(macOS)
            Section {
                footerView
                    .listRowBackground(Color.clear)
            }
#endif
        }
#if os(macOS) || os(iOS)
        .listStyle(.sidebar)
#endif
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
        guard settingsContext.tintColors.count > 0 else {
            return .accentColor
        }
        
        return settingsContext.tintColors.objectOrNil(at: index % settingsContext.tintColors.count) ?? .accentColor
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
