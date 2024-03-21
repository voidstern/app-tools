//
//  UpdateNewsReminder.swift
//  AppTools
//
//  Created by Lukas Burgstaller on 21.03.24.
//

import Foundation
import SFSafeSymbols
import SwiftUI

extension UserSettings.Setting {
    public static var updateNewsVersion: UserSettings.Setting {
        return UserSettings.Setting(identifier: "update_news_version")
    }
}

public class UpdateNewsReminder: ObservableObject {
    private let features: [Feature]
    private let displayBuildVersion: String
    private let upgradeContext: UpgradeContext
    
    @Published public var showUpdateNews: Bool
    
    public init(features: [Feature], upgradeContext: UpgradeContext, displayBuildVersion: String) {
        self.features = features
        self.upgradeContext = upgradeContext
        self.displayBuildVersion = displayBuildVersion
        
        self.showUpdateNews = false
        
        DispatchQueue.main.async(after: 0.5) {
            if self.needsDisplay {
                self.showUpdateNews = true
            }
        }
    }
    
    private var displayName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    private var currentBuild: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    private var installAge: Int {
        return UserSettings.shared.installAge
    }
    
    private var lastBuild: String {
        get { UserSettings.shared.string(key: .updateNewsVersion) }
        set { UserSettings.shared.set(value: newValue, key: .updateNewsVersion) }
    }
    
    public var needsDisplay: Bool {
        return currentBuild != lastBuild && currentBuild == displayBuildVersion && installAge > 0
    }
    
    @ViewBuilder
    public func updateNewsView() -> some View {
        if needsDisplay {
            UpdateNewsView(upgradeContext: upgradeContext, features: features, title: L10n.whatSNewIn(displayName ?? "\(L10n.version) \(displayBuildVersion)"), onContinue: {
                self.lastBuild = self.currentBuild ?? ""
                self.showUpdateNews = false
            })
        } else {
            EmptyView()
        }
    }
}

extension UpdateNewsReminder {
    public struct Feature:  Identifiable {
        let title: String
        let description: String
        let symbol: SFSymbol?
        let tint: Color
        
        public init(_ title: String, description: String, symbol: SFSymbol? = nil, tint: Color = .accentColor) {
            self.description = description
            self.symbol = symbol
            self.title = title
            self.tint = tint
        }
        
        public var id: String {
            title
        }
    }

    public struct Configuration {
        let viewTitle: String
        let primaryButtonTitle: String
        let secondaryButtonTitle: String?
        
        public init(viewTitle: String, primaryButtonTitle: String, secondaryButtonTitle: String?) {
            self.viewTitle = viewTitle
            self.primaryButtonTitle = primaryButtonTitle
            self.secondaryButtonTitle = secondaryButtonTitle
        }
    }
}
