//
//  File.swift
//  
//
//  Created by Lukas Burgstaller on 09.04.24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

struct AboutView: View {
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    
    private let settingsContext: SettingsContext
    
    init(settingsContext: SettingsContext) {
        self.settingsContext = settingsContext
    }
    
    var body: some View {
        content
            .navigationTitle(L10n.about)
    }
    
    var content: some View {
        List {
            Section {
                HStack {
                    Image(settingsContext.appID, bundle: .module)
                    VStack(alignment: .leading) {
                        Text(settingsContext.appName)
                            .fontWeight(.semibold)
                        Text(SupportMailContent().subject())
                            .opacity(0.8)
                    }
                }
                .listRowBackground(Color.clear)
            }
            
            Section(L10n.contact) {
                ButtonSettingsCell(image: Image(systemSymbol: .envelopeFill), title: L10n.email) {
                    SupportMailContent().emailURL(email: settingsContext.supportMail, rcid: subscriptionManager.rcid)?.open()
                }
                
                ButtonSettingsCell(image: Image("TwitterIcon", bundle: .module), title: "Twitter") {
                    URL(string: "https://twitter.com/voidstern")?.open()
                }
                
                ButtonSettingsCell(image: Image("MastodonIcon", bundle: .module), title: "Mastodon") {
                    URL(string: "http://graz.social/web/@voidstern")?.open()
                }
            }
            
            Section(L10n.support) {
                if let userGuideURL = settingsContext.userGuideURL {
                    ButtonSettingsCell(image: Image(systemSymbol: .command), title: L10n.userGuide) {
                        userGuideURL.open()
                    }
                }
                
                if let changelogURL = settingsContext.changelogURL {
                    ButtonSettingsCell(image: Image(systemSymbol: .listBulletClipboard), title: L10n.changelog) {
                        changelogURL.open()
                    }
                }
                
                if let reviewURL = settingsContext.reviewURL {
                    ButtonSettingsCell(image: Image(systemSymbol: .starBubble), title: L10n.review(settingsContext.appName)) {
                        reviewURL.open()
                    }
                }
            }
            
            Section {
                DetailsSettingsCell(setting: .revenuecatUserID, image: Image(systemSymbol: .creditcard), title: "RevenueCat ID", type: .string)
                DetailsSettingsCell(setting: .sentryUserID, image: Image(systemSymbol: .ladybug), title: "Sentry ID", type: .string)
            }
        }
    }
}
