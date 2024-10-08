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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, *)
public struct SettingsView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    @State var showingEmail: Bool = false
    @State var showingiCloud: Bool = false
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    
    @State var showSubscriptionView: Bool = false
    @State var showPurchaseView: Bool = false
    
    private let upgradeContext: UpgradeContext
    private let settingsContext: SettingsContext
    private let content: Content
    private let showDoneButton: Bool
    
    public init(upgradeContext: UpgradeContext, settingsContext: SettingsContext, showDoneButton: Bool = true, @ViewBuilder _ content: () -> Content) {
        self.upgradeContext = upgradeContext
        self.settingsContext = settingsContext
        self.showDoneButton = showDoneButton
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader(content: { geometry in
            Group {
                if geometry.size.width >= 640 {
                    splitViewSettings
                } else {
                    navigationSettings
                }
            }
        })
        .onChange(of: columnVisibility) {
            columnVisibility = .doubleColumn
        }
    }
    
    private var navigationSettings: some View {
        NavigationStack {
            settingsContent(splitView: false)
        }
    }
    
    private var splitViewSettings: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            settingsContent(splitView: true)
                .navigationSplitViewColumnWidth(min: 280, ideal: 320, max: 540)
        } detail: {
            ContentUnavailableView("Nothing selected", systemImage: "gearshape")
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    private func settingsContent(splitView: Bool) -> some View {
        settingsList(splitView: splitView)
            .frame(idealWidth: 360)
#if os(iOS) || os(visionOS)
            .if(!splitView, transform: {
                $0.navigationTitle(L10n.settings)
            })
#endif
            .toolbar(removing: .sidebarToggle)
#if os(iOS) || os(visionOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showDoneButton {
                    ToolbarItem(placement: splitView ? .topBarLeading : .topBarTrailing) {
                        Button(action: dismiss.callAsFunction, label: {
                            Text(L10n.done)
                                .fontWeight(.semibold)
                        })
                    }
                }
            }
#endif
            .navigationDestination(isPresented: $showPurchaseView) {
                PurchaseView(upgradeContext)
            }
            .navigationDestination(isPresented: $showSubscriptionView) {
                SubscriptionStatusView(upgradeContext: upgradeContext, splitView: splitView)
            }
    }
    
    private func settingsList(splitView: Bool) ->  some View {
        List {
            ZStack {
                Color.clear
                
                Group {
                    if subscriptionManager.subscriptionLevel == upgradeContext.subscription.level {
                        PurchaseSettingsProHeader(showSubscriptionView: $showSubscriptionView, upgradeContext: upgradeContext, splitView: splitView)
                            .buttonBorderShape(.roundedRectangle)
                            .selectionDisabled()
                    } else {
                        PurchaseSettingsGetProHeader(showPurchaseView: $showPurchaseView, upgradeContext: upgradeContext, splitView: splitView)
                            .buttonBorderShape(.roundedRectangle)
                            .selectionDisabled()
                    }
                }
            }
#if os(macOS)
            .selectionDisabled()
            .listRowSeparator(.hidden, edges: .all)
            .listRowBackground(Color.clear)
            .buttonStyle(PlainButtonStyle())
#endif
            
            content
            
            Section {
                ButtonSettingsCell(image: Image(systemSymbol: .envelope), title: L10n.email, tint: tint(index: 0)) {
                    SupportMailContent().emailURL(email: settingsContext.supportMail, rcid: subscriptionManager.rcid)?.open()
                }
                
//                if let userGuideURL = settingsContext.userGuideURL {
//                    ButtonSettingsCell(image: Image(systemSymbol: .command), title: L10n.userGuide, tint: tint(index: 3)) {
//                        userGuideURL.open()
//                    }
//                }
                
                NavigationSettingsCell(image: Image(systemSymbol: .infoCircle), title: L10n.about, tint: tint(index: 1)) {
                    AboutView(settingsContext: settingsContext)
                }
            } header: { Text(L10n.support) } footer: { EmptyView() }
            
            Section {
#if !os(macOS)
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
                
//                if settingsContext.appID != "429674741" {
//                    OtherAppSettingsCell(appIcon: Image("429674741", bundle: .module), title: L10n.dozzzerSleepSounds, subtitle: L10n.fallAsleepToMusicSounds) {
//                        URL(string: "https://apps.apple.com/app/apple-store/id429674741")?.open()
//                    }
//                }
                
                if settingsContext.appID != "6478582777" {
                    OtherAppSettingsCell(appIcon: Image("6478582777", bundle: .module), title: L10n.focusedTaskPlanner, subtitle: L10n.oneStepAtATime) {
                        URL(string: "https://apps.apple.com/us/app/focused-task-planner/id6478582777")?.open()
                    }
                }
                
//                if settingsContext.appID != "6479531332" {
//                    OtherAppSettingsCell(appIcon: Image("6479531332", bundle: .module), title: L10n.rcDash, subtitle: L10n.seeYourRevenueCatStatsOnTheGo) {
//                        URL(string: "https://apps.apple.com/us/app/rc-dash/id6479531332")?.open()
//                    }
//                }
                
                
#endif
                NavigationSettingsCell(image: Image(systemSymbol: .listBulletRectangle), title: L10n.otherApps, tint: tint(index: 2)) {
                    allAppView
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
    
    var allAppView: some View {
        List {
            Section(L10n.news) {
                OtherAppSettingsCell(appIcon: Image("1158763303", bundle: .module), title: L10n.fieryFeedsRSSReader, subtitle: L10n.aNewsReaderForPowerUsers) {
                    URL(string: "https://apps.apple.com/app/apple-store/id1158763303")?.open()
                }
            }
            
            Section(L10n.productivity) {
                OtherAppSettingsCell(appIcon: Image("720812035", bundle: .module), title: L10n.tidurMultipleTimers, subtitle: L10n.hiitPomodoroAndMore) {
                    URL(string: "https://apps.apple.com/app/apple-store/id720812035")?.open()
                }
                
                OtherAppSettingsCell(appIcon: Image("6478582777", bundle: .module), title: L10n.focusedTaskPlanner, subtitle: L10n.oneStepAtATime) {
                    URL(string: "https://apps.apple.com/us/app/focused-task-planner/id6478582777")?.open()
                }
            }
            
            Section(L10n.sleep) {
                OtherAppSettingsCell(appIcon: Image("429674741", bundle: .module), title: L10n.dozzzerSleepSounds, subtitle: L10n.fallAsleepToMusicSounds) {
                    URL(string: "https://apps.apple.com/app/apple-store/id429674741")?.open()
                }
            }
            
            Section(L10n.developer) {
                OtherAppSettingsCell(appIcon: Image("6479531332", bundle: .module), title: L10n.rcDash, subtitle: L10n.seeYourRevenueCatStatsOnTheGo) {
                    URL(string: "https://apps.apple.com/us/app/rc-dash/id6479531332")?.open()
                }
            }
        }
        .navigationTitle(L10n.otherApps)
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
